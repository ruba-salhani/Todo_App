import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(
    // Adding ProviderScope enables Riverpod for the entire project
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xfff64444),
          accentColor: Color(0xff757575),
        ),
        home: HomeScreen());
  }
}
