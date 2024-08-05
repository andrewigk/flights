import 'package:cst2335_final_project/database.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cst2335_final_project/reservation/reservations.dart';
import 'package:cst2335_final_project/reservation/reservations_dao.dart';
import 'package:cst2335_final_project/reservation/reservations_repository.dart';
import 'package:intl/intl.dart'; // Import for formatting dates

class AddReservationsPage extends StatefulWidget {
  final ApplicationDatabase database;

  AddReservationsPage({required this.database}); // Initialize with the database from the main app

  @override
  State<AddReservationsPage> createState() => AddReservationsPageState(reservationDao: database.reservationDao); // Pass DAO into the state
}

class AddReservationsPageState extends State<AddReservationsPage> {
  AddReservationsPageState({required this.reservationDao});

  /** Lazy initialization of DAO for future use */
  late ReservationDao reservationDao;

  /** Controllers to handle user input fields */
  late TextEditingController reservationTitleController;
  late TextEditingController customerNameController;
  late TextEditingController destinationController;
  late TextEditingController departureController;
  late TextEditingController arrivalTimeController;
  late TextEditingController departureTimeController;

  @override
  void initState() {
    super.initState();
    reservationTitleController = TextEditingController();
    customerNameController = TextEditingController();
    destinationController = TextEditingController();
    departureController = TextEditingController();
    arrivalTimeController = TextEditingController();
    departureTimeController = TextEditingController();
    loadSharedPreferences();
  }

  @override
  void dispose() {
    super.dispose();
    reservationTitleController.dispose();
    customerNameController.dispose();
    destinationController.dispose();
    departureController.dispose();
    arrivalTimeController.dispose();
    departureTimeController.dispose();
  }

  bool validateUserInputs() {
    if (reservationTitleController.text.isEmpty) return false;
    if (customerNameController.text.isEmpty) return false;
    if (destinationController.text.isEmpty) return false;
    if (departureController.text.isEmpty) return false;
    if (arrivalTimeController.text.isEmpty) return false;
    if (departureTimeController.text.isEmpty) return false;
    return true;
  }

  void closeAlertDialog() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(context, "/reservationsPage");
  }

  void clearUserInputs() {
    setState(() {
      reservationTitleController.clear();
      customerNameController.clear();
      destinationController.clear();
      departureController.clear();
      arrivalTimeController.clear();
      departureTimeController.clear();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    final prefs = EncryptedSharedPreferences();
    var customerName = await prefs.getString("customerName");
    if (customerName != null) {
      customerNameController.text = customerName;
    }
  }

  void saveSharedPreferences() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString("customerName", customerNameController.text);
  }

  void clearSharedPreferences() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.remove("customerName");
    clearUserInputs();
  }

  void alertUserOfSuccessfulInsert() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Database updated"),
        content: const Text("Reservation was successfully added to the database."),
        actions: <Widget>[
          ElevatedButton(
            onPressed: closeAlertDialog,
            child: Text("Ok"),
          )
        ],
      ),
    );
  }

  void createNewReservation() async {
    print("Add new reservation button pressed");
    if (!validateUserInputs()) {
      print("Validation failed");
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Invalid input"),
          content: const Text("One or more input fields are empty."),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Ok"),
            ),
          ],
        ),
      );
    } else {
      var reservation = Reservation(
        Reservation.rID++,
        reservationTitleController.text,
        customerNameController.text,
        destinationController.text,
        departureController.text,
        arrivalTimeController.text,
        departureTimeController.text,
      );
      print("Created reservation: $reservation");

      try {
        await reservationDao.insertReservation(reservation);
        print("Reservation added to the database");
        saveSharedPreferences();
        clearUserInputs();
        alertUserOfSuccessfulInsert();
      } catch (e) {
        print("Error adding reservation: $e");
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Database Error"),
            content: const Text("Failed to add reservation to the database."),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _selectDateTime(TextEditingController controller, bool isDeparture) async {
    final now = DateTime.now();
    final initialDate = controller.text.isNotEmpty ? DateFormat("yyyy-MM-dd").parse(controller.text) : now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year + 100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
        final formattedTime = pickedTime.format(context);
        controller.text = "$formattedDate $formattedTime";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Reservation"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: TextField(
                  controller: reservationTitleController,
                  decoration: InputDecoration(
                    hintText: "Enter Reservation Title:",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: TextField(
                  controller: customerNameController,
                  decoration: InputDecoration(
                    hintText: "Enter Customer Name:",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: TextField(
                  controller: departureController,
                  decoration: InputDecoration(
                    hintText: "Enter Departure City:",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
                child: TextField(
                  controller: destinationController,
                  decoration: InputDecoration(
                    hintText: "Enter Destination City: ",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
                child: TextField(
                  controller: departureTimeController,
                  decoration: InputDecoration(
                    hintText: "Select Departure Time: ",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDateTime(departureTimeController, true),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
                child: TextField(
                  controller: arrivalTimeController,
                  decoration: InputDecoration(
                    hintText: "Select Arrival Time: ",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDateTime(arrivalTimeController, false),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: createNewReservation,
                child: Text("Add new reservation"),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: ElevatedButton(
                  onPressed: clearUserInputs,
                  child: Text("Clear form"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
