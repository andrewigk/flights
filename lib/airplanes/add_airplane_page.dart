

import 'package:flutter/material.dart';

class AddAirplanePage extends StatelessWidget {

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
          child: Text('Airplanes fly')

      ),

    );
  }
}