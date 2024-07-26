import 'package:cst2335_final_project/airplanes/airplane_repository.dart';
import 'package:cst2335_final_project/airplanes/responsive_airplane_details_page.dart';
import 'package:cst2335_final_project/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'airplane.dart';
import 'airplane_details_page.dart';



class AirplanesPage extends StatefulWidget {
  final ApplicationDatabase database;

  AirplanesPage({required this.database});

  @override
  State<AirplanesPage> createState() => AirplanesPageState(database: database);
}

class AirplanesPageState extends State<AirplanesPage> {
  AirplanesPageState({required this.database});

  final canadianEnglishLocale = Locale("en", "ca");
  final americanEnglishLocale = Locale("en", "us");
  final canadianEnglishString = "CA English";
  final americanEnglishString = "US English";
  String currentLanguage = "ca";


  void switchLanguage() {

    setState(() {
      if (currentLanguage == "ca") {
        currentLanguage = "us";
      } else if (currentLanguage == "us") {
        currentLanguage = "ca";
      }
    });
  }

  String getCurrentLanguage() {
    if (currentLanguage == "ca") {
      return canadianEnglishString;
    }

    if (currentLanguage == "us") {
      return americanEnglishString;
    }

    return "English";
  }

  late ApplicationDatabase database;

  List<Airplane> airplanes = [];

  @override
  void initState() {
    super.initState();
    getAirplanesFromDatabase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showHelpSnackBar(); // Show Snackbar after the widget is built
    });
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

  void showHelpSnackBar() {
    setState(() {
      final snackBar = SnackBar(
        content: Text("Need help?"),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Get help',
          onPressed: () {
            displayInstructionDialog();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  displayInstructionDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Welcome to Airplanes page"),
        content: const Text(
            "Click 'add airplane button to create a new plane OR click on an existing airplane to edit or delete it."),
        actions: <Widget>[
          ElevatedButton(
            onPressed: closeInstructionDialog,
            child: Text("Ok"),
          )
        ],
      ),
    );
  }

  void closeInstructionDialog() {
    Navigator.pop(context);
  }

  Future<void> getAirplanesFromDatabase() async {
    final fetchedAirplanes = await database.airplaneDao.getAllAirplanes();

    setState(() {
      airplanes = fetchedAirplanes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > constraints.maxHeight &&
            constraints.maxWidth > 720) {
          return _buildSideBySideView();
        } else {
          return _buildSingleView();
        }
      },
    );
  }

  Widget _buildSideBySideView() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Airplanes page"),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: navigateToAddAirplanePage,
                  child: Text("Add new airplane"),
                ),
                ElevatedButton(
                  onPressed: switchLanguage,
                  child: Text("Switch language, current language: ${getCurrentLanguage()}"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: airplanes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          AirplaneRepository.selectedAirplane =
                          airplanes[index];
                          setState(() {

                            Navigator.pop(context); // go all the way home
                            Navigator.pushNamed(context, "/airplanesPage");
                          }); // Refresh the side-by-side view
                        },
                        child: ListTile(
                          title: Text(
                            "ID: ${airplanes[index].airplaneId}"
                                " Type: ${airplanes[index].airplaneType}"
                                " Passengers: ${airplanes[index].numberOfPassengers}"
                                " Max speed (km/h): ${airplanes[index].maxSpeed}"
                                " Range (km): ${airplanes[index].range}",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ResponsiveAirplaneDetailsPage(database: database),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleView() {
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
              child: Text("Add new airplane"),
            ),
            ElevatedButton(
              onPressed: switchLanguage,
              child: Text("Switch language, current language: ${getCurrentLanguage()}"),
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
                            " Max speed (km/h): ${airplanes[index].maxSpeed}"
                            " Range (km): ${airplanes[index].range}",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
