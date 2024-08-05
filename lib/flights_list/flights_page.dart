import 'package:cst2335_final_project/database.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_flights_page.dart';
import 'flights.dart';
import 'flights_dao.dart';
import 'flights_repository.dart';


class FlightsPage extends StatefulWidget {
  final ApplicationDatabase database;

  FlightsPage({required this.database}); // take the database from main

  @override
  State<FlightsPage> createState() => FlightsPageState(flightDao: database.flightDao, database: database); // pass your DAO into the state to use it

}

class FlightsPageState extends State<FlightsPage> {

  FlightsPageState({required this.flightDao, required this.database});

  /** The instance of the flight DAO that performs DB operations. */
  late FlightDao flightDao;
  /** The instance of the database that is already initialized in main. */
  final ApplicationDatabase database;

  late TextEditingController destinationController;
  late TextEditingController departureController;
  late TextEditingController arrivalTimeController;
  late TextEditingController departureTimeController;

  /** A list of Flight objects to store objects created in runtime. */
  List<Flight> flights = [];

  /** A variable to store a specific instance of a Flight. */
  Flight? selectedItem;

  /** A variable to store the specific row number or index from a ListView for
   * use in later logic.
   */
  int selectedRow = 0;

  @override
  void initState() {
    super.initState();
    destinationController = TextEditingController();
    departureController = TextEditingController();
    arrivalTimeController = TextEditingController();
    departureTimeController = TextEditingController();
    flightDao = database.flightDao;   // should initialize DAO object
    flightDao.getAllFlights().then(  (listOfAllItems) {   // get all existing items then load into list to be displayed in listview
      setState(() {
        flights.addAll(listOfAllItems);
      });

    });
  }


  @override
  void dispose() {
    super.dispose();
    destinationController.dispose();
    departureController.dispose();
    arrivalTimeController.dispose();
    departureTimeController.dispose();
  }

  /** Saves shared preferences when called, setting the repository values then
   * calling the save function for persistence.
   */
  void saveSharedPreferences() async {
    FlightRepository.departureCity = departureController.text;
    FlightRepository.destinationCity = destinationController.text;
    FlightRepository.departureTime = arrivalTimeController.text;
    FlightRepository.arrivalTime = departureTimeController.text;
    FlightRepository.saveData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text("Flights Page"),
          actions: [
            ElevatedButton(child: Text("Help"), onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                  AlertDialog(
                    title: const Text('How to Use:'),
                    actions: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add new flights by clicking the 'Add new flight route' button.",
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Click or tap on a flight in the list to view more details and update/delete existing flights.",
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tap anywhere to exit this dialog.",
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ));

              }),

            ElevatedButton(child: Text("Back to List"), onPressed: () {
              setState(() {
                selectedItem = null;
              });
            }),
          ],
        ),
        body: responsiveLayout(context));  // body for the main build widget is responsiveLayout
  }

  /** responsiveLayout takes a media query, sets variables, then performs conditional
   * logic based on the dimensions of the display.
   */
  Widget responsiveLayout(BuildContext context){
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    // If in landscape orientation
    if((width>height) && (width>720)){
      return Row(children: [
          Expanded( flex:2, child: FlightList(context)),
           Expanded( flex:1, child: DetailsPage()),
      ]);
    }
    // Portrait orientation
    else {
      if (selectedItem == null) {
        return FlightList(context);
      }
      else {
        return DetailsPage();
      }
    }
  }

  /** Flight List displays Listview of all flights */
  Widget FlightList(BuildContext context){
    return Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/addFlightsPage");
                  },
                  child: Text("Add new flight route"))
            ]),
          ),
          Builder(
              builder: (BuildContext context) {
                if (flights.isEmpty) {
                  return Padding(padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("List of flight routes is currently empty.")
                          ]));
                }
                else {
                  return
                    Expanded(child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child:
                        ListView.builder(
                            itemCount: flights.length,
                            itemBuilder: (context, rowNum) {
                              return Padding(
                                  padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                                  child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      color: Colors.deepPurple[100],
                                      child:
                                      GestureDetector(
                                      child:
                                      Column(mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                          children: [
                                              Text("Flight Number: ${rowNum + 1} "),
                                            Text("Departure: ${flights[rowNum].departureCity}"),
                                            Text("Destination: ${flights[rowNum].destinationCity}"),
                                           Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                             children: [
                                               Text("Departure Time: ${flights[rowNum].departureTime}"),
                                               Text("Arrival Time: ${flights[rowNum].arrivalTime}")
                                             ]
                                          )

                                          ]),
                                        onTap: () {
                                          setState(() {
                                            selectedItem = flights[rowNum];   // On tap of an item, sets listview-local variables to instance variables
                                            selectedRow = rowNum;             // for later use.
                                          });
                                          departureController.text = flights[rowNum].departureCity;
                                          destinationController.text = flights[rowNum].destinationCity;
                                          departureTimeController.text = flights[rowNum].departureTime;
                                          arrivalTimeController.text = flights[rowNum].arrivalTime;

                                          saveSharedPreferences();


                                        },
                                      ),
                                  ));
                            }
                        ))
                    );
                }
              }),
        ]);
  }

  /** Details Page displays a very similar view to add new flight, but replaces the add button
   * with an update and delete button. Only displays when an item in the listview is
   * selected.
   */
  Widget DetailsPage() {
    if (selectedItem == null) {
      return Text("");
    }
    else {
      return Padding(padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: Container(
            padding: const EdgeInsets.all(4.0),
            // color: Colors.deepPurple[100],
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child:
                    TextField(
                      controller: departureController,
                      decoration: InputDecoration(
                        hintText: "Enter Departure City:",
                        border: OutlineInputBorder(),
                        labelText: "Departure"
                      ),
                    )),
                    Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child:
                    TextField(
                      controller: destinationController,
                      decoration: InputDecoration(
                        hintText: "Enter Destination City: ",
                        border: OutlineInputBorder(),
                        labelText: "Destination"
                      ),
                    )),
                    Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child:
                      TextField(
                      controller: departureTimeController,
                      decoration: InputDecoration(
                        hintText: "Enter Departure Time (24HR): ",
                        border: OutlineInputBorder(),
                        labelText: "Departure Time"
                      ),
                    )),
                    Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child:TextField(
                      controller: arrivalTimeController,
                      decoration: InputDecoration(
                        hintText: "Enter Arrival Time (24HR): ",
                        border: OutlineInputBorder(),
                        labelText: "Arrival Time"
                      ),
                    )),
                    Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child:
                        ElevatedButton(child: Text("Update Flight"), onPressed: () {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                      title: const Text('Update?'),
                                      content: const Text(
                                          'Confirm update details?'),
                                      actions: <Widget>[
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: <Widget>[
                                              OutlinedButton(onPressed: () {
                                                // Set the specific selected item instance to update
                                               selectedItem?.departureCity = departureController.text;
                                               selectedItem?.destinationCity =destinationController.text;
                                               selectedItem?.departureTime = departureTimeController.text;
                                               selectedItem?.arrivalTime = arrivalTimeController.text;
                                                setState(() {
                                                  // Process the update via the DAO and then reset the selectedItem reference
                                                  flightDao.updateFlight(
                                                      selectedItem!);
                                                  selectedItem = null;
                                                  Navigator.pop(context);
                                                });
                                              },
                                                  child: Text("Yes")),
                                              OutlinedButton(onPressed: () {
                                                Navigator.pop(context);
                                              },
                                                  child: Text("No"))

                                            ]
                                        )

                                      ]));
                        }
                        )),
                    Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child:
                        ElevatedButton(child: Text("Delete Flight"), onPressed: () {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                      title: const Text('Delete?'),
                                      content: const Text(
                                          'Are you sure you want to delete this flight?'),
                                      actions: <Widget>[
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: <Widget>[
                                              OutlinedButton(onPressed: () {
                                                setState(() {
                                                  // Call the DAO function on the specific flight instance stored in DB
                                                  flightDao.deleteFlight(
                                                      selectedItem!);
                                                  // Then remove the local instance of flight from the List[]
                                                  flights.removeAt(selectedRow);
                                                  selectedItem = null;
                                                  Navigator.pop(context);
                                                });
                                              },
                                                  child: Text("Yes")),
                                              OutlinedButton(onPressed: () {
                                                Navigator.pop(context);
                                              },
                                                  child: Text("No"))

                                            ]
                                        )

                                      ]));
                        }
                        )),
                  ],
                )
            ),
        ),


      );
    }
  }
}





