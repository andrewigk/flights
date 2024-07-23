import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customer_repository.dart';

// Page to add customers.
class CustomerAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomerAddState();
  }
}


class CustomerAddState extends State<CustomerAdd> {
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _address;
  late TextEditingController _birthday;
  List<String> customerList = [];

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _address = TextEditingController();
    _birthday = TextEditingController();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _address.dispose();
    _birthday.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Add a New Customer", style: TextStyle(fontSize: 30)),
                Container(
                    width: 500,
                    child: TextField(
                        controller: _firstName,
                        decoration: InputDecoration(
                            hintText: "First Name",
                            border: OutlineInputBorder()
                        )
                    )
                ),
                Container(
                    width: 500,
                    child: TextField(
                        controller: _lastName,
                        decoration: InputDecoration(
                            hintText: "Last Name",
                            border: OutlineInputBorder()
                        )
                    )
                ),
                Container(
                    width: 500,
                    child: TextField(
                        controller: _address,
                        decoration: InputDecoration(
                            hintText: "Address",
                            border: OutlineInputBorder()
                        )
                    )
                ),
                Container(
                    width: 500,
                    child: TextField(
                        controller: _birthday,
                        decoration: InputDecoration(
                            hintText: "Birthday",
                            border: OutlineInputBorder()
                        )
                    )
                ),
                OutlinedButton(child:
                Text("Save New Customer"),
                    onPressed: (){
                      var newFName = _firstName.value.text;
                      var newLName = _lastName.value.text;
                      var newAddress = _address.value.text;
                      var newBirthday = _birthday.value.text;

                      setState(() {
                        customerList.add(newFName);
                        customerList.add(newLName);
                        customerList.add(newAddress);
                        customerList.add(newBirthday);
                      });
                    }
                ),
                ElevatedButton(child:
                Text("Return to Customer List"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            )
        )
    );
  }
}