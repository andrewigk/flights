
import 'package:cst2335_final_project/airplanes/airplane_repository.dart';
import 'package:cst2335_final_project/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'airplane.dart';

/*
* CRITERIA FOR AIRPLANES PAGE:
* - Listview displaying all planes
* - button to add plane -> add new plane form (submit/insert new plane button)
*     -> adding plane has shared preferences, displaying previously entered plane details
* - click on plane -> details form (with update, delete buttons)
*   -> populate form with current airplane details
* */

// TODO: make pretty
// TODO: Keep list up to date after, insertions, deletes, updates


class AirplanesPage extends StatefulWidget {
  final ApplicationDatabase database;

  AirplanesPage({required this.database});

  @override
  State<AirplanesPage> createState() => AirplanesPageState(database: database);

}


class AirplanesPageState extends State<AirplanesPage> {

  AirplanesPageState({required this.database});

  late ApplicationDatabase database;

  List<Airplane> airplanes = [];

  @override
  void initState() {
    super.initState();
    getAirplanesFromDatabase();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigateToAddAirplanePage() {
    Navigator.pushNamed(context, "/addAirplanePage");
  }

  void navigateToAirplaneDetailsPage(BuildContext context, Airplane airplane) {
    AirplaneRepository.selectedAirplane = airplane;
    Navigator.pushNamed(context, "/airplaneDetailsPage");
  }

  Future<void> getAirplanesFromDatabase() async {
    final fetchedAirplanes = await database.airplaneDao.getAllAirplanes();

    setState(() {
      airplanes = fetchedAirplanes;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Airplanes page"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: navigateToAddAirplanePage,
                  child: Text("Add new airplane")
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: airplanes.length,
                    itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        navigateToAirplaneDetailsPage(context, airplanes[index]);
                      },
                      child: ListTile(
                        title: Text(
                            "ID: ${airplanes[index].airplaneId}"
                            " Type: ${airplanes[index].airplaneType}"
                                " Passengers: ${airplanes[index].numberOfPassengers}"
                                " Max speed (km/h): ${airplanes[index].range}"
                                " Range (km): ${airplanes[index].range}"
                        ),

                      ),
                    );
                    },
                ),
              ),
            ],
          )
      ),
    );
  }
}