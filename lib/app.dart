import 'package:flutter/material.dart';
import 'package:flutter_projects/features/auth/screens/auth_screen.dart';
import 'shared/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фильмотека',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const AuthScreen(),
    );
  }
}