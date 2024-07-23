import 'package:cst2335_final_project/airplanes/add_airplane_page.dart';
import 'package:cst2335_final_project/airplanes/airplanes_page.dart';
import 'package:cst2335_final_project/flights_list/add_flights_page.dart';
import 'package:flutter/material.dart';
import 'database.dart';
import 'flights_list/flights_page.dart';

void main() async { // DO NOT MODIFY THIS CODE!!!!!!!!!!!!
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
        '/addFlightsPage' : (context) => AddFlightsPage(database: database)


        // ^^^^^^you guys can add your routes to pages here
        // IMPORTANT: MAKE SURE TO PASS THE DATABASE TO YOUR PAGES AS PARAMETER
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

  void navigateToCustomersListPage() {}

  void navigateToFlightsListPage() {}

  void navigateToReservations() {}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: navigateToCustomersListPage,
                    child: Text("Customers list page") ),
                ElevatedButton(
                    onPressed: navigateToAirplanesPage,
                    child: Text("Airplanes page") ),
                ElevatedButton(
                    onPressed: navigateToFlightsListPage,
                    child: Text("Flights list page") ),
                ElevatedButton(
                    onPressed: navigateToReservations,
                    child: Text("Reservations page") ),
              ],
          )
        ],
        ),
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
