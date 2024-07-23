import 'package:cst2335_final_project/airplanes/airplane.dart';
import 'package:cst2335_final_project/airplanes/airplane_dao.dart';
import 'package:cst2335_final_project/airplanes/airplane_repository.dart';
import 'package:cst2335_final_project/database.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';


class AddAirplanePage extends StatefulWidget {
  final ApplicationDatabase database;


  AddAirplanePage({required this.database}); // take the database from main

  @override
  State<AddAirplanePage> createState() => AddAirplanePageState(airplaneDao: database.airplaneDao);
}

class AddAirplanePageState extends State<AddAirplanePage> {

  AddAirplanePageState({required this.airplaneDao});

  late AirplaneDao airplaneDao;

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

    loadSharedPreferences();

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
    Navigator.pop(context); // go back to airplanes page?
  }

  void clearUserInputs(){
    setState(() {
      airplaneTypeController.clear();
      numberOfPassengersController.clear();
      maxSpeedController.clear();
      rangeController.clear();
    });
  }

  Future<void> addAirplaneToDatabase(Airplane airplane) async {
    await airplaneDao.insertAirplane(airplane);
  }

  Future<void> loadSharedPreferences() async {
    AirplaneRepository.loadData();
    airplaneTypeController.text = AirplaneRepository.airplaneType;
    numberOfPassengersController.text = AirplaneRepository.numberOfPassengers;
    maxSpeedController.text = AirplaneRepository.maxSpeed;
    rangeController.text = AirplaneRepository.range;

  }


  void saveSharedPreferences() async {
   AirplaneRepository.airplaneType = airplaneTypeController.text;
   AirplaneRepository.numberOfPassengers = numberOfPassengersController.text;
   AirplaneRepository.maxSpeed = maxSpeedController.text;
   AirplaneRepository.range = rangeController.text;
   AirplaneRepository.saveData();
  }

  void clearSharedPreferences() async {
    AirplaneRepository.airplaneType = "";
    AirplaneRepository.numberOfPassengers = "";
    AirplaneRepository.maxSpeed = "";
    AirplaneRepository.range = "";
    AirplaneRepository.saveData();
    clearUserInputs();
  }

  void alertUserOfSuccessfulInsert(){
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Database updated"),
          content: const Text("Airplane was added to database successfully."),
          actions: <Widget>[
            ElevatedButton(
                onPressed: closeAlertDialog,
                child: Text("Ok"),
            )
          ],
        )
    );
  }

  void createNewAirplane(){

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
          airplaneType: airplaneTypeUserInput,
          numberOfPassengers: int.parse(numberOfPassengerUserInput),
          maxSpeed: int.parse(maxSpeedUserInput),
          range: int.parse(rangeUserInput)
      );

      // add airplane to database
      addAirplaneToDatabase(airplane);
      saveSharedPreferences();
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
                  onPressed: createNewAirplane,
                  child: Text("Add new airplane to database")),
              ElevatedButton(
                  onPressed: clearUserInputs,
                  child: Text("Clear form")),
              ElevatedButton(
                  onPressed: clearSharedPreferences,
                  child: Text("Clear preferences")),
            ],
          )
      ),
    );
  }
}
