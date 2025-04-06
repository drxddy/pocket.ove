import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pocket/presentation/presentation.dart';

import 'domain/services/services.dart';

void main() async {
  BootstrapService.start(() {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(context),
      home: const PocketApp(),
    );
  }

  ThemeData _buildTheme(context) {
    return ThemeData(
      textTheme: GoogleFonts.interTextTheme(
        TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),

          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onBackground,
          ),


          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onBackground,
          ),

          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onBackground,
          ),

          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onBackground,
          ),


          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onBackground,
          ),

          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onBackground,
          ),

          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onBackground,
          ),


          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onBackground,
          ),


          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onBackground,
          ),

          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),


          displaySmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ) 
      )
    );
  }
}
