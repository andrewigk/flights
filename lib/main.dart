import 'package:cst2335_final_project/airplanes/add_airplane_page.dart';
import 'package:cst2335_final_project/airplanes/airplane_details_page.dart';
import 'package:cst2335_final_project/airplanes/airplanes_page.dart';
import 'package:cst2335_final_project/flights_list/add_flights_page.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'customers/customer_add.dart';
import 'customers/customer_page.dart';
import 'database.dart';
import 'flights_list/flights_page.dart';

void main() async { // DO NOT MODIFY THIS CODE!!!!!!!!!!!!
  // WE ARE ALL USING THE SAME SHARED DATABASE
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorApplicationDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final ApplicationDatabase database;

  const MyApp({super.key, required this.database});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App title',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/airplanesPage': (context) => AirplanesPage(database: database),
        '/addAirplanePage': (context) => AddAirplanePage(database: database),
        '/flightsPage' : (context) => FlightsPage(database: database),
        '/addFlightsPage' : (context) => AddFlightsPage(database: database),
        '/airplaneDetailsPage': (context) => AirplaneDetailsPage(database: database),
        '/customersPage' : (context) => CustomerPage(database: database),
        '/addCustomersPage' : (context) => CustomerAdd(database: database)


        // ^^^^^^you guys can add your routes to pages here
        // IMPORTANT: MAKE SURE TO PASS THE DATABASE AND PREFERENCES TO YOUR PAGES AS PARAMETER (IF YOU NEED THEM)
    },

      home: MyHomePage(title: 'CST2335 Project', database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.database});

  final String title;
  final ApplicationDatabase database;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  void navigateToAirplanesPage() {
      Navigator.pushNamed(context, "/airplanesPage");
  }

  // you can implment these methods with your route name like i did ^^^
  // all the buttons are already hooked up to these functions
  //VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

  void navigateToCustomersListPage() {
    Navigator.pushNamed(context, "/customersPage");
  }

  void navigateToFlightsListPage() {
    Navigator.pushNamed(context, "/flightsPage");
  }

  void navigateToReservations() {}


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    // If landscape:
    if((width>height) && (width>720)){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Expanded(child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.fromLTRB(6,0,6,0),
                    child:
                    ElevatedButton(
                        onPressed: navigateToCustomersListPage,
                        child: Text("Customers list page") )),
                Padding(padding: EdgeInsets.fromLTRB(6,0,6,0),
                    child:ElevatedButton(
                        onPressed: navigateToAirplanesPage,
                        child: Text("Airplanes page") )),
                Padding(padding: EdgeInsets.fromLTRB(6,0,6,0),
                    child:ElevatedButton(
                        onPressed: navigateToFlightsListPage,
                        child: Text("Flights list page") )),
                Padding(padding: EdgeInsets.fromLTRB(6,0,6,0),
                    child:ElevatedButton(
                        onPressed: navigateToReservations,
                        child: Text("Reservations page") )),
              ],
          )
        )],
        ),
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
    else{
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                   child:
                  ElevatedButton(
                      onPressed: navigateToCustomersListPage,
                      child: Text("Customers list page") )),
                  Padding(padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child:ElevatedButton(
                      onPressed: navigateToAirplanesPage,
                      child: Text("Airplanes page") )),
                    Padding(padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child:ElevatedButton(
                      onPressed: navigateToFlightsListPage,
                      child: Text("Flights list page") )),
                    Padding(padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child:ElevatedButton(
                      onPressed: navigateToReservations,
                      child: Text("Reservations page") )),
                ],
              )
              )],
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      );

    }
}
}