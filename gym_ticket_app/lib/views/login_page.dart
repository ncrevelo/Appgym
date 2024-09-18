import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = Get.put(AuthService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bienvenido de nuevo",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 30),

              // Campo de Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),

              // Campo de Contraseña
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  hintText: 'Contraseña',
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[700],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 30),

              // Botón de Iniciar Sesión
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Validar campos antes de iniciar sesión
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Por favor, complete todos los campos',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  // Lógica de iniciar sesión
                  bool success = authService.login(
                    emailController.text,
                    passwordController.text,
                  );
                  if (success) {
                    Get.to(() => HomePage());
                  } else {
                    Get.snackbar(
                      'Error',
                      'Usuario no registrado o contraseña incorrecta',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text("Iniciar Sesión"),
              ),
              SizedBox(height: 10),

              // Botón de Registro
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Validar campos antes de registrarse
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Por favor, complete todos los campos',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  // Lógica de registro
                  bool success = authService.register(
                    emailController.text,
                    passwordController.text,
                  );
                  if (success) {
                    Get.snackbar(
                      'Éxito',
                      'Usuario registrado exitosamente',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'El usuario ya está registrado',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text("Registrarse"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

