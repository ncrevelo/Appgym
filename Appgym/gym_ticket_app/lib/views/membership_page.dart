import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import 'package:table_calendar/table_calendar.dart';

class MembershipPage extends StatefulWidget {
  @override
  _MembershipPageState createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  final AuthService authService = Get.find<AuthService>();
  List<DateTime> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compra de Tickets"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Membresía Mensual
            MembershipOption(
              title: "Membresía Mensual",
              description: "Acceso completo por 30 días",
              buttonColor: Colors.green,
              onPressed: () {
                // Comprar Membresía Mensual
                authService.buyMembership(30);
                mostrarMensajeExito('Membresía Mensual comprada con éxito');
              },
            ),
            SizedBox(height: 20),

            // Membresía Anual
            MembershipOption(
              title: "Membresía Anual",
              description: "Acceso completo por 365 días",
              buttonColor: Colors.blue,
              onPressed: () {
                // Comprar Membresía Anual
                authService.buyMembership(365);
                mostrarMensajeExito('Membresía Anual comprada con éxito');
              },
            ),
            SizedBox(height: 20),

            // Membresía Tiquetera
            MembershipOption(
              title: "Membresía Tiquetera",
              description: "Selecciona los días que deseas asistir",
              buttonColor: Colors.orange,
              onPressed: () {
                // Mostrar calendario para la tiquetera
                _showTiqueteraDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo para la tiquetera
  void _showTiqueteraDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Selecciona los días de asistencia",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  width: 350,  // Limitar el ancho del calendario
                  child: TableCalendar(
                    firstDay: DateTime.utc(2022, 01, 01),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: DateTime.now(),
                    selectedDayPredicate: (day) {
                      return selectedDays.contains(day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        if (selectedDays.contains(selectedDay)) {
                          selectedDays.remove(selectedDay);
                        } else {
                          selectedDays.add(selectedDay);
                        }
                      });
                    },
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(
                        color: Colors.black, // Color de los días por defecto
                      ),
                      weekendTextStyle: TextStyle(
                        color: Colors.black, // Color de los días del fin de semana
                      ),
                      outsideTextStyle: TextStyle(
                        color: Colors.grey, // Días fuera del mes
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text("Confirmar Selección"),
                  onPressed: () {
                    // Registrar los días seleccionados
                    authService.selectTrainingDays(selectedDays);
                    // Mostrar mensaje de éxito
                    mostrarMensajeExito('Has comprado una tiquetera con ${selectedDays.length} días');
                    Get.back();  // Volver al Home después de comprar la tiquetera
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // Función para mostrar mensaje de éxito
  void mostrarMensajeExito(String mensaje) {
    Get.snackbar(
      'Éxito',
      mensaje,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }
}

class MembershipOption extends StatelessWidget {
  final String title;
  final String description;
  final Color buttonColor;
  final VoidCallback onPressed;

  MembershipOption({
    required this.title,
    required this.description,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.fitness_center),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
            ),
            onPressed: onPressed,
            label: Text("Comprar"),
          ),
        ],
      ),
    );
  }
}





