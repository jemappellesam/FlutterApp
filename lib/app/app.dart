import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../screens/profile_selection_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Rosarium',
      theme: AppTheme.darkTheme,
      home: const ProfileSelectionScreen(),
    );
  }
}