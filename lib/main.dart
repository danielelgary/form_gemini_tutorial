import 'package:flutter/material.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/complex_form_page.dart';
import 'package:form_gemini_tutorial/welcome_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          //child: ComplexFormPage(),
          child: WelcomeScreen(),
        ),
      ),
    );
  }
}
