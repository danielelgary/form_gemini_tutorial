// lib/welcome_screen.dart
// Pantalla de bienvenida con animación y redirección automática.
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:form_gemini_tutorial/features/complex_form/view/choice_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Hacemos visible el logo después de un breve momento para crear el efecto de aparición
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });

    // Navegamos a la siguiente pantalla después de 3 segundos
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ChoiceScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFE0E0E0);
    const Color darkTextColor = Color(0xFF2C2C2C);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: const Duration(seconds: 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TuFuente', // Reemplaza con tu fuente si tienes una
                  ),
                  children: [
                    const TextSpan(
                      text: 'habi',
                      style: TextStyle(color: darkTextColor),
                    ),
                    TextSpan(
                      text: 'Go',
                      style: TextStyle(
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: <Color>[Color(0xFF4A89F3), Color(0xFF3C47E4)],
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 150.0, 70.0)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tu habilitación, a un solo Go.',
                style: TextStyle(fontSize: 18, color: darkTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}