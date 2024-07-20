
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AirplanesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    void navigateHome() {
      Navigator.pop(context);
    }

    void navigateToAddAirplanePage() {
      Navigator.pushNamed(context, "/addAirplanePage");
    }

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
                  child: Text("Add new airplane"))
            ],
          )

          ),
    );
  }
}
