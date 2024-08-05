import 'package:cst2335_final_project/database.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cst2335_final_project/reservation/add_reservations_page.dart';
import 'package:cst2335_final_project/reservation/reservations.dart';
import 'package:cst2335_final_project/reservation/reservations_dao.dart';
import 'package:cst2335_final_project/reservation/reservations_repository.dart';

class ReservationsPage extends StatefulWidget {
  final ApplicationDatabase database;

  ReservationsPage({required this.database}); // Accept the database instance

  @override
  State<ReservationsPage> createState() => ReservationsPageState(
    reservationDao: database.reservationDao,
    database: database,
  ); // Initialize the state with the DAO and database
}

class ReservationsPageState extends State<ReservationsPage> {
  ReservationsPageState({
    required this.reservationDao,
    required this.database,
  });

  /** Instance of the Reservation DAO used for database operations. */
  late ReservationDao reservationDao;
  /** Instance of the application database. */
  final ApplicationDatabase database;

  late TextEditingController reservationTitleController;
  late TextEditingController customerNameController;
  late TextEditingController destinationController;
  late TextEditingController departureController;
  late TextEditingController arrivalTimeController;
  late TextEditingController departureTimeController;

  /** List to store reservation objects created at runtime. */
  List<Reservation> reservations = [];

  /** Holds the currently selected reservation for detailed view or editing. */
  Reservation? selectedItem;

  /** Index of the currently selected reservation in the list. */
  int selectedRow = 0;

  @override
  void initState() {
    super.initState();
    destinationController = TextEditingController();
    departureController = TextEditingController();
    arrivalTimeController = TextEditingController();
    departureTimeController = TextEditingController();
    reservationDao = database.reservationDao; // Initialize DAO
    reservationDao.getAllReservations().then((listOfAllItems) {
      setState(() {
        reservations.addAll(listOfAllItems);
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

  /** Saves current input values to shared preferences for persistence. */
  void saveSharedPreferences() async {
    ReservationRepository.departureCity = departureController.text;
    ReservationRepository.destinationCity = destinationController.text;
    ReservationRepository.departureTime = arrivalTimeController.text;
    ReservationRepository.arrivalTime = departureTimeController.text;
    ReservationRepository.saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Reservations Page"),
        actions: [
          ElevatedButton(
            child: Text("Info"),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Information:'),
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
                                "Click the 'Add New Reservation' button to create a new reservation.",
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
                                "Choose a reservation from the list to view its details or to modify/delete it.",
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
                                "Click anywhere outside this dialog to close it.",
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: responsiveLayout(context),
    );
  }

  /** Provides a responsive layout based on the screen dimensions. */
  Widget responsiveLayout(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    // Landscape orientation
    if ((width > height) && (width > 720)) {
      return Row(
        children: [
          Expanded(flex: 2, child: ReservationList(context)),
          Expanded(flex: 1, child: DetailsPage()),
        ],
      );
    }
    // Portrait orientation
    else {
      if (selectedItem == null) {
        return ReservationList(context);
      } else {
        return DetailsPage();
      }
    }
  }

  /** Displays a list of reservations. */
  Widget ReservationList(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/addReservationsPage");
                },
                child: Text("Add new reservation"),
              ),
            ],
          ),
        ),
        Builder(
          builder: (BuildContext context) {
            if (reservations.isEmpty) {
              return Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("No reservations available.")],
                ),
              );
            } else {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: ListView.builder(
                    itemCount: reservations.length,
                    itemBuilder: (context, rowNum) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.deepPurple[100],
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Reservation Number: ${rowNum + 1} "),
                                Text("Departure: ${reservations[rowNum].departureCity}"),
                                Text("Destination: ${reservations[rowNum].destinationCity}"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Departure Time: ${reservations[rowNum].departureTime}"),
                                    Text("Arrival Time: ${reservations[rowNum].arrivalTime}"),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                selectedItem = reservations[rowNum]; // Update state with selected reservation
                                selectedRow = rowNum; // Store index of selected reservation
                              });
                              departureController.text = reservations[rowNum].departureCity;
                              destinationController.text = reservations[rowNum].destinationCity;
                              departureTimeController.text = reservations[rowNum].departureTime;
                              arrivalTimeController.text = reservations[rowNum].arrivalTime;

                              saveSharedPreferences();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  /** Displays details of the selected reservation, with options to update or delete it. */
  Widget DetailsPage() {
    if (selectedItem == null) {
      return Text("");
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: Container(
          padding: const EdgeInsets.all(4.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Text(
                    "Reservation Title: ${selectedItem!.reservationTitle}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Text(
                    "Customer Name: ${selectedItem!.customerName}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: TextField(
                    controller: departureController,
                    decoration: InputDecoration(
                      hintText: "Enter Departure City:",
                      border: OutlineInputBorder(),
                      labelText: "Departure",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      hintText: "Enter Destination City:",
                      border: OutlineInputBorder(),
                      labelText: "Destination",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: TextField(
                    controller: departureTimeController,
                    decoration: InputDecoration(
                      hintText: "Select Departure Time:",
                      border: OutlineInputBorder(),
                      labelText: "Departure Time",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: TextField(
                    controller: arrivalTimeController,
                    decoration: InputDecoration(
                      hintText: "Select Arrival Time:",
                      border: OutlineInputBorder(),
                      labelText: "Arrival Time",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: ElevatedButton(
                    child: Text("Update Reservation"),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Update?'),
                          content: const Text('Are you sure you want to update the reservation?'),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                OutlinedButton(
                                  onPressed: () {
                                    selectedItem?.departureCity = departureController.text;
                                    selectedItem?.destinationCity = destinationController.text;
                                    selectedItem?.departureTime = departureTimeController.text;
                                    selectedItem?.arrivalTime = arrivalTimeController.text;
                                    setState(() {
                                      reservationDao.updateReservation(selectedItem!);
                                      selectedItem = null;
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text("Yes"),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: ElevatedButton(
                    child: Text("Delete Reservation"),
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete?'),
                          content: const Text('Are you sure you want to delete this reservation?'),
                          actions: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      reservationDao.deleteReservation(selectedItem!);
                                      reservations.removeAt(selectedRow);
                                      selectedItem = null;
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text("Yes"),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
