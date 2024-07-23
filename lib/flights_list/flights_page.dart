import 'package:cst2335_final_project/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlightsPage extends StatelessWidget {
  final ApplicationDatabase database;

  FlightsPage({required this.database});

  @override
  Widget build(BuildContext context) {

    void navigateToAddFlightsPage() {
      Navigator.pushNamed(context, "/addFlightsPage");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Flights Page"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: navigateToAddFlightsPage,
                  child: Text("Add new flight route"))
            ],
          )

      ),
    );
  }
}
