import 'package:cst2335_final_project/airplanes/airplane_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database.dart';
import 'airplane.dart';
import 'airplane_dao.dart';

class AirplaneDetailsPage extends StatefulWidget {
  final ApplicationDatabase database;

  AirplaneDetailsPage({required this.database});

  @override
  State<AirplaneDetailsPage> createState() => AirplaneDetailsPageState(airplaneDao: database.airplaneDao);
}

class AirplaneDetailsPageState extends State<AirplaneDetailsPage> {

  AirplaneDetailsPageState({required this.airplaneDao});

  final AirplaneDao airplaneDao;
  final originalAirplane = AirplaneRepository.selectedAirplane;

  late TextEditingController airplaneTypeController;
  late TextEditingController numberOfPassengersController;
  late TextEditingController maxSpeedController;
  late TextEditingController rangeController;

  @override
  void initState() {
    super.initState();
    airplaneTypeController = TextEditingController();
    numberOfPassengersController = TextEditingController();
    maxSpeedController = TextEditingController();
    rangeController = TextEditingController();
    loadOriginalAirplaneDetails();

  }

  @override
  void dispose() {
    super.dispose();
    airplaneTypeController.dispose();
    numberOfPassengersController.dispose();
    maxSpeedController.dispose();
    rangeController.dispose();
  }

  bool validateUserInputs() {

    String airplaneTypeUserInput = airplaneTypeController.value.text;
    String numberOfPassengerUserInput = numberOfPassengersController.value.text;
    String maxSpeedUserInput = maxSpeedController.value.text;
    String rangeUserInput = rangeController.value.text;

    if (airplaneTypeUserInput == "") {
      return false;
    }

    if (numberOfPassengerUserInput == "") {
      return false;
    }

    if (maxSpeedUserInput == "") {
      return false;
    }

    if (rangeUserInput == "") {
      return false;
    }

    return true;
  }

  void closeAlertDialog() {
    Navigator.pop(context); // close alert
    Navigator.pop(context); // go back to airplanes page
    Navigator.pop(context); // go all the way home
    Navigator.pushNamed(context, "/airplanesPage"); // back to airplanes page
  }

  void clearUserInputs(){
    setState(() {
      airplaneTypeController.clear();
      numberOfPassengersController.clear();
      maxSpeedController.clear();
      rangeController.clear();
    });
  }

  void loadOriginalAirplaneDetails() {
    setState(() {
      airplaneTypeController.text = originalAirplane!.airplaneType;
      numberOfPassengersController.text = originalAirplane!.numberOfPassengers.toString();
      maxSpeedController.text = originalAirplane!.maxSpeed.toString();
      rangeController.text = originalAirplane!.range.toString();
    });
  }

  Future<void> updateAirplaneToDatabase(Airplane airplane) async {
    await airplaneDao.updateAirplane(airplane);
  }

  Future<void> deleteAirplaneFromDatabase(Airplane airplane) async {
    await airplaneDao.deleteAirplane(airplane);
  }



  void alertUserOfSuccessfulInsert(){
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Database updated"),
          content: const Text("Database was updated successfully."),
          actions: <Widget>[
            ElevatedButton(
              onPressed: closeAlertDialog,
              child: Text("Ok"),
            )
          ],
        )
    );
  }

  void updateAirplane() {

    String airplaneTypeUserInput = airplaneTypeController.value.text;
    String numberOfPassengerUserInput = numberOfPassengersController.value.text;
    String maxSpeedUserInput = maxSpeedController.value.text;
    String rangeUserInput = rangeController.value.text;

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
      Airplane airplane = Airplane(
        airplaneId: originalAirplane?.airplaneId,
          airplaneType: airplaneTypeUserInput,
          numberOfPassengers: int.parse(numberOfPassengerUserInput),
          maxSpeed: int.parse(maxSpeedUserInput),
          range: int.parse(rangeUserInput)
      );

      // add airplane to database
      updateAirplaneToDatabase(airplane);
      clearUserInputs();
      alertUserOfSuccessfulInsert();
    }
  }

  void deleteAirplane() {
      // add airplane to database
    deleteAirplaneFromDatabase(originalAirplane!);
    clearUserInputs();
    alertUserOfSuccessfulInsert();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add airplane"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: airplaneTypeController,
                decoration: InputDecoration(
                  hintText: "Enter air plane type",
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller:numberOfPassengersController,
                decoration: InputDecoration(
                  hintText: "Enter # of passengers",
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: maxSpeedController,
                decoration: InputDecoration(
                  hintText: "Enter maximum speed (km/h)",
                  border: OutlineInputBorder(),
                ),
              ),
              TextField(
                controller: rangeController,
                decoration: InputDecoration(
                  hintText: "Enter range in km",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                  onPressed: deleteAirplane,
                  child: Text("Delete")),
              ElevatedButton(
                  onPressed: updateAirplane,
                  child: Text("Update database")),
              ElevatedButton(
                  onPressed: clearUserInputs,
                  child: Text("Clear form")),
            ],
          )
      ),
    );
  }
}