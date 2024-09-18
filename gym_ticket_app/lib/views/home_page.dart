import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import 'membership_page.dart';

class HomePage extends StatelessWidget {
  final AuthService authService = Get.find<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido ${authService.currentUser}"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authService.logout();
              Get.offAllNamed('/');
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.05, // Ajuste horizontal
              vertical: constraints.maxHeight * 0.02,  // Ajuste vertical
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progreso de Membresía
                Container(
                  height: constraints.maxHeight * 0.2, // Ajuste de altura relativo
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: authService.membershipDays.value > 0
                      ? Center(
                          child: Stack(
                            children: [
                              CircularProgressIndicator(
                                value: authService.membershipProgress.value,
                                strokeWidth: 8,
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                              Center(
                                child: Text(
                                  '${(authService.membershipProgress.value * 100).toInt()}%',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                            "Compra una membresía para comenzar",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                ),
                SizedBox(height: constraints.maxHeight * 0.02), // Espaciado ajustado

                if (authService.membershipDays.value > 0)
                  Center(
                    child: Text(
                      "Progreso de Membresía\n${authService.membershipDays.value} días restantes",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: constraints.maxHeight * 0.02),

                // Días seleccionados para la tiquetera (si aplica)
                if (authService.selectedTrainingDays.isNotEmpty) ...[
                  Text(
                    "Días seleccionados para la tiquetera:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Column(
                    children: authService.selectedTrainingDays
                        .map((day) => ListTile(
                              title: Text(
                                "${day.day}/${day.month}/${day.year}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                ],

                // Formulario de entrenamiento
                Text(
                  "Registrar Entrenamiento",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey),
                ),
                SizedBox(height: constraints.maxHeight * 0.01),

                // Campos del formulario
                ...buildExerciseFormFields(constraints),

                // Entrenamientos registrados
                Text(
                  "Entrenamientos Registrados",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (authService.workouts.isEmpty)
                  Text(
                    "No hay entrenamientos registrados",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: authService.workouts.length,
                    itemBuilder: (context, index) {
                      final workout = authService.workouts[index];
                      return Card(
                        color: Colors.grey[800],
                        child: ListTile(
                          title: Text(
                            workout['exercise'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            "Duración: ${workout['duration']} min, Calorías: ${workout['calories']}",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[400]),
                          ),
                        ),
                      );
                    },
                  ),
                SizedBox(height: constraints.maxHeight * 0.02),

                // Botón para comprar membresía
                ElevatedButton.icon(
                  icon: Icon(Icons.fitness_center),
                  label: Text("Comprar Membresía"),
                  onPressed: () {
                    Get.to(() => MembershipPage());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Método auxiliar para crear los campos del formulario
  List<Widget> buildExerciseFormFields(BoxConstraints constraints) {
    return [
      TextField(
        decoration: InputDecoration(
          labelText: "Tipo de Ejercicio",
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[700],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          authService.exerciseType = value;
        },
      ),
      SizedBox(height: constraints.maxHeight * 0.02),
      TextField(
        decoration: InputDecoration(
          labelText: "Duración (min)",
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[700],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          authService.duration = value;
        },
      ),
      SizedBox(height: constraints.maxHeight * 0.02),
      TextField(
        decoration: InputDecoration(
          labelText: "Calorías Quemadas",
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[700],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          authService.caloriesBurned = value;
        },
      ),
      SizedBox(height: constraints.maxHeight * 0.02),
      ElevatedButton(
        onPressed: () {
          if (authService.exerciseType.isNotEmpty &&
              authService.duration.isNotEmpty &&
              authService.caloriesBurned.isNotEmpty) {
            authService.addWorkout(
              authService.exerciseType,
              authService.duration,
              authService.caloriesBurned,
            );
            Get.snackbar(
              'Éxito',
              'Entrenamiento registrado exitosamente',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              'Error',
              'Completa todos los campos antes de registrar',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 24),
            SizedBox(width: 5),
            Text("Agregar Entrenamiento"),
          ],
        ),
      ),
      SizedBox(height: constraints.maxHeight * 0.02),
    ];
  }
}
