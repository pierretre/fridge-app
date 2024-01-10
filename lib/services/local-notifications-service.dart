import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fridge_app/models/product.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsService {
  
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  factory LocalNotificationsService() {
    initialize();
    return LocalNotificationsService._internal();
  }

  LocalNotificationsService._internal();

  static void initialize() async {
    // Initialization  setting for android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log("notif received " + details.input.toString());
      },
    );

    tz.initializeTimeZones();
    log("notif service initialised");
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    log("showNotification()");
    const details = NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
    return _notificationsPlugin.show(id, title, body, details);
  }

  /**
   * The goal is to schedule notifications based on the products registered.
   * 
   * One idea could be to sen a notification just before the product reaches the expiration date but a notification for each item would be to much.
   * 
   * Another idead is to generate a notification for the day just before the closest expiring product reaches the date, with all products to consume in the following days. 
   */
  scheduleNotificationBasedOnProducts(List<Product> products) async {
    // filter products to get only the ones after the current date
    final filteredItems =
        products.where((element) => element.expiresOn.isAfter(DateTime.now()));

    // Cancel already registered notifications
    _notificationsPlugin.cancelAll();

    // For each product, generate the notification that will appear the day before it expires :
    // We also want to include in it the items that will expire in the 7 following days
    for (var item in filteredItems) {
      // Get all products that expire the week following the first product :
      final productsExpiringTheWeekAfter = products.where((p) => p.expiresOn.difference(item.expiresOn).abs().inDays <= 7); // TODO

      // The date the notification will be sent
      final tmpDateTime = item.expiresOn.subtract(const Duration(days: 1));

      // The final date is the day before product expires at 18:00
      final nextNotificationDate =
          DateTime(tmpDateTime.year, tmpDateTime.month, tmpDateTime.day, 18);

      final nextNotificationId =
          (await _notificationsPlugin.pendingNotificationRequests()).length;

      // log("loc = ${tz.local}");
      await _notificationsPlugin.zonedSchedule(
          nextNotificationId,
          "A product has reached expiring date",
          "${item.label} will expire on ${item.expiresOn}",
          tz.TZDateTime.now(tz.local)
              .add(DateTime.now().difference(nextNotificationDate).abs()),
          const NotificationDetails(
              android: AndroidNotificationDetails('channelId', 'channelName',
                  importance: Importance.max),
              iOS: DarwinNotificationDetails()),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
    // log((await _notificationsPlugin.pendingNotificationRequests())
    //     .map((e) => "(${e.id}, ${e.body})")
    //     .toString());
  }
}
