import 'package:flutter/material.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:provider/provider.dart';
import 'pages/homepage.dart';

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
        colorSchemeSeed: const Color.fromARGB(255, 176, 235, 108),
        bottomSheetTheme: const BottomSheetThemeData(
          // backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}
