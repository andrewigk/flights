

import 'package:flutter/material.dart';

class AddAirplanePage extends StatefulWidget {

  const AddAirplanePage({super.key, required this.title});

  final String title;

  @override
  State<AddAirplanePage> createState() => AddAirplanePageState();


  @override
  Widget build(BuildContext context) {

    void navigateHome() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add airplane"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(),
              TextField(),

            ],
          )

      ),

    );
  }
}

class AddAirplanePageState extends State<AddAirplanePage> {

  // airplane type
  // # of passengers
  // max speed
  // range in KM
  // VALIDATE ALL

  late TextEditingController airplaneTypeController;
  late TextEditingController numberOfPassengersController;
  late TextEditingController maxSpeedController;
  late TextEditingController rangeController;

  @override
  void initState() {
    super.initState();
  }

}
