import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/consultation/mode_selection_screen.dart';

void main() {
  runApp(const ProviderScope(child: HairConsultationApp()));
}

class HairConsultationApp extends StatelessWidget {
  const HairConsultationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Hair Consultation',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF7F4EE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD6A62C),
        ),
      ),
      home: const ModeSelectionScreen(),
    );
  }
}