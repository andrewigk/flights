import 'package:cst2335_final_project/customers/customer.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database.dart';
import 'customer_dao.dart';
import 'customer_repository.dart';

// Page to add customers.
class CustomerAdd extends StatefulWidget {
  final ApplicationDatabase database;
  final Customer? customer;

  CustomerAdd({required this.database, this.customer}); // take the database from main

  @override
  State<CustomerAdd> createState() => CustomerAddState(customerDao: database.customerDao);
}


class CustomerAddState extends State<CustomerAdd> {
  CustomerAddState({required this.customerDao, this.customer});

  late CustomerDao customerDao;
  final Customer? customer;


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

    if (widget.customer != null) {
      _firstName.text = widget.customer!.firstName;
      _lastName.text = widget.customer!.lastName;
      _address.text = widget.customer!.address;
      _birthday.text = widget.customer!.birthday;
    }

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Add a new customer'),
    //         duration: Duration(seconds: 5),
    //       )
    //   );
    // });
  }

  @override
  void dispose() {
    saveCustomerData();
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

  void saveCustomerData() async {
    CustomerRepository.firstName = _firstName.text;
    CustomerRepository.lastName = _lastName.text;
    CustomerRepository.address = _address.text;
    CustomerRepository.birthday = _birthday.text;
    CustomerRepository.saveData();
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

      customerDao.insertCustomer(customer).then((_) {
        Navigator.pushNamed(context,  "/customersPage");
      });

      clearUserInputs();

    }
  }

  void updateCustomer() {
    if (!validateUserInputsCustomer()) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Invalid input"),
          content: const Text("At least one of your inputs was left empty."),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () { Navigator.pop(context); },
              child: Text("Ok"),
            ),
          ],
        ),
      );
    } else {
      var updatedCustomer = Customer(
        widget.customer!.customerId,
        _firstName.text,
        _lastName.text,
        _address.text,
        _birthday.text,
      );
      customerDao.updateCustomer(updatedCustomer).then((_) {
        Navigator.pushNamed(context, '/customersPage');
      });
      }
      }

  void deleteCustomer() {
      customerDao.deleteCustomer(widget.customer!).then((_) {
        Navigator.pushNamed(context, '/customersPage');
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Customer Details", style: TextStyle(fontSize: 30)),
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
                OutlinedButton(child:
                Text("Update Customer"),
                    onPressed: (){
                      updateCustomer();
                    }
                ),
                OutlinedButton(child:
                Text("Delete Customer"),
                    onPressed: (){
                      deleteCustomer();
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