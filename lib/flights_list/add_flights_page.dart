import 'package:cst2335_final_project/airplanes/airplane.dart';
import 'package:cst2335_final_project/airplanes/airplane_dao.dart';
import 'package:cst2335_final_project/database.dart';
import 'package:flutter/material.dart';

import 'flights.dart';
import 'flights_dao.dart';

class AddFlightsPage extends StatefulWidget {
  final ApplicationDatabase database;

  AddFlightsPage({required this.database}); // take the database from main

  @override
  State<AddFlightsPage> createState() => AddFlightsPageState(flightDao: database.flightDao); // pass your DAO into the state to use it

}

class AddFlightsPageState extends State<AddFlightsPage> {

  AddFlightsPageState({required this.flightDao});


  late FlightDao flightDao;

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
  }

  @override
  void dispose() {
    super.dispose();
    destinationController.dispose();
    departureController.dispose();
    arrivalTimeController.dispose();
    departureTimeController.dispose();
  }

  bool validateUserInputs() {

    if (destinationController.value.text == "") {
      return false;
    }

    if (departureController.value.text == "") {
      return false;
    }
    //TODO: Implement a more robust validation to parse the entered string and
    //TODO: validate that it's an actual time
    if (arrivalTimeController.value.text == "") {
      return false;
    }

    if (departureTimeController.value.text == "") {
      return false;
    }

    return true;
  }

  void closeAlertDialog() {
    Navigator.pop(context);
    Navigator.pushNamed(context, "/flightsPage");
  }

  void clearUserInputs(){
    setState(() {
      destinationController.clear();
      departureController.clear();
      arrivalTimeController.clear();
      departureTimeController.clear();
    });
  }
/*
  Future<void> addAirplaneToDatabase(Airplane airplane) async {
    await airplaneDao.insertAirplane(airplane);
  }

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
      clearUserInputs();
      alertUserOfSuccessfulInsert();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add airplane"),
      ),
      body: Center(
          child:
            SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: departureController,
                decoration: InputDecoration(
                  hintText: "Enter Departure City:",
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  hintText: "Enter Destination City: ",
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: departureTimeController,
                decoration: InputDecoration(
                  hintText: "Enter Departure Time (24HR): ",
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: arrivalTimeController,
                decoration: InputDecoration(
                  hintText: "Enter Arrival Time (24HR): ",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                  onPressed: createNewFlight,
                  child: Text("Add new flight route to database")),
              ElevatedButton(
                  onPressed: clearUserInputs,
                  child: Text("Clear form")),
            ],
          )
      ),
    ));
  }
}
