// lib/features/complex_form/view/submission_result_page.dart
import 'package:flutter/material.dart';

class SubmissionResultPage extends StatelessWidget {
  final bool success;
  final String message;

  const SubmissionResultPage({
    super.key,
    required this.success,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(success ? 'Envío Exitoso' : 'Error en el Envío'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                success ? Icons.check_circle_outline : Icons.error_outline,
                color: success ? Colors.green : Colors.red,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                success ? '¡Formulario Enviado!' : 'Ocurrió un Problema',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Vuelve al inicio de la aplicación
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Volver al Inicio'),
              )
            ],
          ),
        ),
      ),
    );
  }
}