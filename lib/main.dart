import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var apptheme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "To Do",
      theme: apptheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages : [
        GetPage(name: '/', page: () => const HomePage()),
      ]
      
    );
  }
}

