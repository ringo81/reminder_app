import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const YuruReminderApp());
}

class YuruReminderApp extends StatelessWidget {
  const YuruReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ゆるリマインダー',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainLightBlue,
          background: backgroundGry,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundGry,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        scaffoldBackgroundColor: backgroundGry,
        fontFamily: 'Hiragino Sans',
      ),
      home: const HomeScreen(),
    );
  }
}
