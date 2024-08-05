import 'package:cst2335_final_project/airplanes/airplane.dart';
import 'package:cst2335_final_project/airplanes/airplane_dao.dart';
import 'package:cst2335_final_project/database.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';

import 'flights.dart';
import 'flights_dao.dart';
import 'flights_repository.dart';

class AddFlightsPage extends StatefulWidget {
  final ApplicationDatabase database;

  AddFlightsPage({required this.database}); // take the database from main

  @override
  State<AddFlightsPage> createState() => AddFlightsPageState(flightDao: database.flightDao); // pass your DAO into the state to use it

}

class AddFlightsPageState extends State<AddFlightsPage> {

  AddFlightsPageState({required this.flightDao});

  /** Late initialization of DAO so that we can use it later */
  late FlightDao flightDao;

  /** Text editing controllers for user input */
  late TextEditingController destinationController;
  late TextEditingController departureController;
  late TextEditingController arrivalTimeController;
  late TextEditingController departureTimeController;


  @override
  void initState() {
    super.initState();
    destinationController = TextEditingController();
    departureController = TextEditingController();
    arrivalTimeController = TextEditingController();
    departureTimeController = TextEditingController();
    loadSharedPreferences();


  }

  @override
  void dispose() {
    super.dispose();
    destinationController.dispose();
    departureController.dispose();
    arrivalTimeController.dispose();
    departureTimeController.dispose();
  }

  /** Validates user inputs and returns a boolean. */
  bool validateUserInputs() {

    if (destinationController.value.text == "") {
      return false;
    }

    if (departureController.value.text == "") {
      return false;
    }

    if (arrivalTimeController.value.text == "") {
      return false;
    }

    if (departureTimeController.value.text == "") {
      return false;
    }

    return true;
  }

  /** Closes an alert dialog by popping to the previous page, then returning to
   * the main flight page.
   */
  void closeAlertDialog() {
    Navigator.pop(context);
    Navigator.pop(context);
    //Navigator.pushNamed(context, "/flightsPage");
  }

  /** Clears user inputs in the text fields when called.
   *
   */
  void clearUserInputs(){
    setState(() {
      destinationController.clear();
      departureController.clear();
      arrivalTimeController.clear();
      departureTimeController.clear();
    });
  }

  /** Special function required to be called to resolve conflicts with
   * states and loading of various elements at init.
   */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadSharedPreferences();
  }

  /** Loads data that is set to shared preferences, and displays a notification
   * if data is loaded into the text fields.
   */
  Future<void> loadSharedPreferences() async {
    FlightRepository.loadData();
    departureController.text = FlightRepository.departureCity;
    destinationController.text = FlightRepository.destinationCity;
    arrivalTimeController.text = FlightRepository.departureTime;
    departureTimeController.text = FlightRepository.arrivalTime;
    var departure = departureController.text;
    var destination = destinationController.text;
    var arrivalTime = arrivalTimeController.text;
    var departureTime = departureTimeController.text;

    if (departure != "" || destination != "" || arrivalTime != "" || departureTime != "") {
      final snackBar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Previously selected flight details have been loaded.')),
            SnackBarAction(
              label: 'Clear Saved Data',
              onPressed: () {
                EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
                prefs.remove("departureCity");
                prefs.remove("destinationCity");
                prefs.remove("departureTime");
                prefs.remove("arrivalTime");
                clearSharedPreferences();
              },
            ),
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }



  }

  /** Saves shared preferences when called, setting the repository values then
   * calling the save function for persistence.
   */
  void saveSharedPreferences() async {
    final prefs = EncryptedSharedPreferences();
    FlightRepository.departureCity = departureController.text;
    FlightRepository.destinationCity = destinationController.text;
    FlightRepository.departureTime = arrivalTimeController.text;
    FlightRepository.arrivalTime = departureTimeController.text;
    FlightRepository.saveData();
  }

  /** Clears the shared preferences stored, and clears user inputs from
   * text fields.
   */
  void clearSharedPreferences() async {
    FlightRepository.departureCity = "";
    FlightRepository.destinationCity = "";
    FlightRepository.departureTime = "";
    FlightRepository.arrivalTime = "";
    FlightRepository.saveData();
    clearUserInputs();
  }


  /** Creates an alert dialog that notifies user that an insert was successful.
   *
   */
  void alertUserOfSuccessfulInsert(){
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Database updated"),
          content: const Text("Flight was added to database successfully."),
          actions: <Widget>[
            ElevatedButton(
              onPressed: closeAlertDialog,
              child: Text("Ok"),
            )
          ],
        )
    );
  }

  /** Adds an entry to the DB if validation succeeds.
   *
   */
  void createNewFlight(){
    if (!validateUserInputs()) { // Alert user of invalid empty inputs
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Invalid input"),
            content: const Text("At least one of your inputs was left empty."),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: closeAlertDialog,
                  child: Text("Ok")
              )
            ],
          )
      );
    } else {
      // create an airplane with user inputs
      var flight = Flight(
          Flight.ID++, destinationController.value.text,
          departureController.value.text, arrivalTimeController.value.text,
          departureTimeController.value.text
      );
      // add flight to database
      flightDao.insertFlight(flight);
      // Save shared preferences so that the most recently added flight is loaded
      saveSharedPreferences();
      clearUserInputs();
      alertUserOfSuccessfulInsert();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Flight"),
      ),
      body: Center(
          child:
            SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
              child: TextField(
                controller: departureController,
                decoration: InputDecoration(
                  hintText: "Enter Departure City:",
                  border: OutlineInputBorder(),
                ),
              )),
          Padding(padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
            child:
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  hintText: "Enter Destination City: ",
                  border: OutlineInputBorder(),
                ),
              )),
          Padding(padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: TextField(
                controller: departureTimeController,
                decoration: InputDecoration(
                  hintText: "Enter Departure Time (24HR): ",
                  border: OutlineInputBorder(),
                ),
              )),
            Padding(padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
            child:  TextField(
                controller: arrivalTimeController,
                decoration: InputDecoration(
                  hintText: "Enter Arrival Time (24HR): ",
                  border: OutlineInputBorder(),
                ),
              )),
              ElevatedButton(
                  onPressed: createNewFlight,
                  child: Text("Add new flight route to database")),
          Padding(padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: ElevatedButton(
                  onPressed: clearUserInputs,
                  child: Text("Clear form"))),
            ],
          )
      ),
    ));
  }

}
