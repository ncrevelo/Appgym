import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Obtenemos el tamaño de la pantalla usando MediaQuery
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        double textScaleFactor = screenWidth / 375; // Asumiendo 375 como tamaño de referencia

        return GetMaterialApp(
          title: 'Gym Ticket App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            textTheme: TextTheme(
              // Ajustamos el tamaño del texto basado en el ancho de la pantalla
              titleLarge: TextStyle(
                fontSize: 32 * textScaleFactor,  // Escalado de texto
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                fontSize: 16 * textScaleFactor,
                color: Colors.white,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontSize: 18 * textScaleFactor,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1, // Ajustar el padding del botón
                  vertical: screenHeight * 0.02,
                ),
              ),
            ),
          ),
          home: LoginPage(),
        );
      },
    );
  }
}

