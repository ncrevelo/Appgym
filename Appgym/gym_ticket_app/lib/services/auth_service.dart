import 'package:get/get.dart';

class AuthService extends GetxController {
  final users = <String, String>{}.obs;  // Almacena los usuarios
  final isLoggedIn = false.obs;
  final currentUser = ''.obs;
  final membershipDays = 0.obs;  // Días restantes de la membresía
  final membershipProgress = 0.0.obs;  // Progreso de la membresía (0.0 a 1.0)
  final selectedTrainingDays = <DateTime>[].obs;  // Días seleccionados para la tiquetera
  final workouts = <Map<String, dynamic>>[].obs;  // Lista de entrenamientos registrados

  String exerciseType = '';
  String duration = '';
  String caloriesBurned = '';

  // Método para registrar un nuevo usuario
  bool register(String email, String password) {
    if (users.containsKey(email)) {
      return false;  // El usuario ya está registrado
    }
    users[email] = password;
    return true;
  }

  // Método para iniciar sesión
  bool login(String email, String password) {
    if (users[email] == password) {
      currentUser.value = email;
      isLoggedIn.value = true;
      return true;
    }
    return false;  // Usuario no encontrado o contraseña incorrecta
  }

  // Método para cerrar sesión
  void logout() {
    isLoggedIn.value = false;
    currentUser.value = '';
    membershipDays.value = 0;
    membershipProgress.value = 0.0;
    workouts.clear();  // Limpiar los entrenamientos cuando el usuario cierre sesión
  }

  // Método para comprar una membresía (mensual, anual o tiquetera)
  void buyMembership(int days) {
    membershipDays.value = days;
    _updateMembershipProgress(days);
  }

  // Método privado para actualizar el progreso de la membresía
  void _updateMembershipProgress(int days) {
    if (days > 0) {
      // Para una membresía mensual o anual, ajustamos el progreso
      if (days == 30) {
        membershipProgress.value = days / 30;  // Membresía mensual
      } else if (days == 365) {
        membershipProgress.value = days / 365;  // Membresía anual
      } else {
        membershipProgress.value = days / days;  // Membresía por tiquetera (número de días seleccionados)
      }
    } else {
      membershipProgress.value = 0.0;  // Sin membresía
    }
  }

  // Método para seleccionar días de entrenamiento con la tiquetera
  void selectTrainingDays(List<DateTime> days) {
    selectedTrainingDays.assignAll(days);
    buyMembership(days.length);  // Usar el número de días seleccionados para la membresía
  }

  // Método para agregar un entrenamiento
  void addWorkout(String exercise, String duration, String calories) {
    workouts.add({
      'exercise': exercise,
      'duration': duration,
      'calories': calories,
    });
  }
}

