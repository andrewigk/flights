import 'package:cst2335_final_project/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_flights_page.dart';
import 'flights.dart';
import 'flights_dao.dart';


/*
class FlightsPage extends StatelessWidget {
  final ApplicationDatabase database;


  FlightsPage({required this.database});

}*/


class FlightsPage extends StatefulWidget {
  final ApplicationDatabase database;

  FlightsPage({required this.database}); // take the database from main

  @override
  State<FlightsPage> createState() => FlightsPageState(flightDao: database.flightDao, database: database); // pass your DAO into the state to use it

}

class FlightsPageState extends State<FlightsPage> {

  FlightsPageState({required this.flightDao, required this.database});

  late FlightDao flightDao;
  final ApplicationDatabase database;

  List<Flight> flights = [];

  Flight? selectedItem;
  int selectedRow = 0;

  @override
  void initState() {
    super.initState();
    flightDao = database.flightDao;   // should initialize DAO object
    flightDao.getAllFlights().then(  (listOfAllItems) {
      setState(() {
        flights.addAll(listOfAllItems);
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Flights Page"),
          actions: [
            ElevatedButton(child: Text("Back to List"), onPressed: () {
              setState(() {
                selectedItem = null;
              });
            }),
          ],
        ),
        body: responsiveLayout(context));
  }

  Widget responsiveLayout(BuildContext context){
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    // If in landscape orientation
    if((width>height) && (width>720)){
      if(selectedItem == null){
        return Row(children: [
            Expanded( flex:2, child: FlightList(context)),
            Expanded( flex:1, child: Text("")),
      ]);
      }
      else{
        return Row(children: [
          Expanded( flex:2, child: FlightList(context)),
          Expanded( flex:1, child: AddFlightsPage(database: database)),
        ]);
      }

    }
    // Portrait orientation
    else {
      if (selectedItem == null) {
        return FlightList(context);
      }
      else {
        return AddFlightsPage(database: database);
      }
    }
  }
  Widget FlightList(BuildContext context){
    return Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
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
                                            selectedItem = flights[rowNum];
                                            selectedRow = rowNum;
                                          });
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

  Widget DetailsPage() {
    if (selectedItem == null) {
      return Text("");
    }
    else {
      return Padding(padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Container(
            padding: const EdgeInsets.all(10.0),
            color: Colors.deepPurple[100],
            child:
            Column(mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.fromLTRB(16, 64, 16, 0),
                            child: Text("Flight selected is: ",
                                style: TextStyle(fontSize: 16))
                        )
                      ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                            child:
                            Text(selectedItem!.flightId.toString(),
                                style: TextStyle(fontSize: 18)))
                      ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                            child: Text("Departure city is: ${selectedItem!.departureCity}",
                                style: TextStyle(fontSize: 12))),
                      ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                            child: Text("Destination city is: ${selectedItem!.destinationCity}",
                                style: TextStyle(fontSize: 12))),
                      ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                            child: Text("Departure time is: ${selectedItem!.departureTime}",
                                style: TextStyle(fontSize: 12))),
                      ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                            child: Text("Arrival time is: ${selectedItem!.arrivalTime}",
                                style: TextStyle(fontSize: 12))),
                      ]),
                  Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child:
                      ElevatedButton(child: Text("Update Task"), onPressed: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                    title: const Text('Update?'),
                                    content: const Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: <Widget>[
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          children: <Widget>[
                                            OutlinedButton(onPressed: () {
                                              setState(() {
                                                flightDao.deleteFlight(
                                                    selectedItem!);
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
                  Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child:
                      ElevatedButton(child: Text("Delete Task"), onPressed: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                    title: const Text('Delete?'),
                                    content: const Text(
                                        'Are you sure you want to delete this item?'),
                                    actions: <Widget>[
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          children: <Widget>[
                                            OutlinedButton(onPressed: () {
                                              setState(() {
                                                flightDao.deleteFlight(
                                                    selectedItem!);
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
                ])),


      );
    }
  }
}





