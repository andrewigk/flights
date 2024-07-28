import 'package:cst2335_final_project/customers/customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database.dart';
import 'customer_dao.dart';
import 'customer_repository.dart';

// Page to add customers.
class CustomerAdd extends StatefulWidget {
  final ApplicationDatabase database;

  CustomerAdd({required this.database}); // take the database from main

  @override
  State<CustomerAdd> createState() => CustomerAddState(customerDao: database.customerDao);
}


class CustomerAddState extends State<CustomerAdd> {
  CustomerAddState({required this.customerDao});

  late CustomerDao customerDao;


  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _address;
  late TextEditingController _birthday;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _address = TextEditingController();
    _birthday = TextEditingController();

    CustomerRepository.loadData().then((_) {
      setState(() {
        _firstName.text = CustomerRepository.firstName;
        _lastName.text = CustomerRepository.lastName;
        _address.text = CustomerRepository.address;
        _birthday.text = CustomerRepository.birthday;
      });
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _address.dispose();
    _birthday.dispose();
    super.dispose();
  }

  bool validateUserInputsCustomer() {
    if (_firstName.value.text == "") {
      return false;
    }
    if (_lastName.value.text == "") {
      return false;
    }
    if (_address.value.text == "") {
      return false;
    }
    if (_birthday.value.text == "") {
      return false;
    }
    return true;
  }

  void closeAlertDialog() {
    Navigator.pop(context);
    Navigator.pushNamed(context, "/customersPage");
  }

  void clearUserInputs(){
    setState(() {
      _firstName.clear();
      _lastName.clear();
      _address.clear();
      _birthday.clear();
    });
  }


  void addNewCustomer() {
    if (!validateUserInputsCustomer()) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
        title: const Text("Invalid input"),
        content: const Text("At least one of your inputs was left empty."),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () {Navigator.pop(context);},
              child: Text("Ok")
          )
        ],
      ));
    } else {
      var customer = Customer(Customer.cID, _firstName.value.text,
          _lastName.value.text, _address.value.text, _birthday.value.text);

      customerDao.insertCustomer(customer);
      clearUserInputs();

    }
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
                      addNewCustomer();
                    }
                ),
                ElevatedButton(child:
                Text("Return to Customer List"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/customersPage');
                    })
              ],
            )
        )
    );
  }
}