
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AirplanesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Airplanes page"),
      ),
      body: Center(
          child: Text('Airplanes fly')),
    );
  }
}
