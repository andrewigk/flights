import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  late TextEditingController _email;
  late TextEditingController _birthday;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _email = TextEditingController();
    _birthday = TextEditingController();
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
                        controller: _email,
                        decoration: InputDecoration(
                            hintText: "Email",
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