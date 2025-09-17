import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos los colores para que sean fáciles de cambiar después
    const Color backgroundColor = Color(0xFFE0E0E0); // Un gris claro similar al de la imagen
    const Color darkTextColor = Color(0xFF2C2C2C); // Un color oscuro para el texto y el ícono

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Contenido Central (Logo y Eslogan)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- USA ESTA OPCIÓN SI EXPORTAS EL LOGO COMO IMAGEN (RECOMENDADO) ---
                  // Image.asset(
                  //   'assets/images/habigo_logo.png', // Asegúrate de tener esta ruta en tu proyecto
                  //   width: 200, // Ajusta el tamaño según sea necesario
                  // ),

                  //--- (Opcional) Si quieres recrear el logo con texto y gradiente ---
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TuFuente', // Reemplaza con tu fuente
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
                  
                  const SizedBox(height: 16), // Espacio entre el logo y el eslogan

                  const Text(
                    'Tu habilitación, a un solo Go.',
                    style: TextStyle(
                      fontSize: 18,
                      color: darkTextColor,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Botón de Navegación en la esquina inferior derecha
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(24.0), // Espacio desde los bordes
                child: FloatingActionButton(
                  onPressed: () {
                    // TODO: Aquí va la navegación a la siguiente pantalla
                    print("Botón presionado!");
                  },
                  backgroundColor: Colors.white,
                  elevation: 4.0, // Sombra del botón
                  child: const Icon(
                    Icons.arrow_forward,
                    color: darkTextColor,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}