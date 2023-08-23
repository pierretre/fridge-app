import 'package:flutter/material.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductListModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.lightGreenAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}
