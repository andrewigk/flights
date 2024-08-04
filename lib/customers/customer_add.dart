import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database.dart';
import 'customer.dart';
import 'customer_dao.dart';
import 'customer_repository.dart';

/// This is the class to add customers to the database.
class CustomerAdd extends StatefulWidget {
  // Database instance.
  final ApplicationDatabase database;
  // Customer object.
  final Customer? customer;
  // Constructor to initialize the database with this customer.
  CustomerAdd({required this.database, this.customer});

  @override
  State<CustomerAdd> createState() => CustomerAddState(customerDao: database.customerDao);
}

class CustomerAddState extends State<CustomerAdd> {
  /// Creates a CustomerAddState instance with a customerDao and this database.
  CustomerAddState({required this.customerDao, this.customer});
  /// Declaring data access object for customer.
  late CustomerDao customerDao;
  /// Declaring a customer object.
  final Customer? customer;
  /// Declaring text editing controllers for text fields.
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _address;
  late TextEditingController _birthday;

  @override
  void initState() {
    super.initState();
    // Initializing text editing controllers.
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _address = TextEditingController();
    _birthday = TextEditingController();

    // Checks if a customer object is provided, if it is, insert values into
    // text fields.
    if (widget.customer != null) {
      _firstName.text = widget.customer!.firstName;
      _lastName.text = widget.customer!.lastName;
      _address.text = widget.customer!.address;
      _birthday.text = widget.customer!.birthday;
    }
  }

  @override
  void dispose() {
    // Saves customer data into repository.
    saveCustomerData();
    _firstName.dispose();
    _lastName.dispose();
    _address.dispose();
    _birthday.dispose();
    super.dispose();
  }

  /// This function validates that the text fields are not left empty.
  bool validateUserInputsCustomer() {
    return _firstName.value.text.isNotEmpty &&
        _lastName.value.text.isNotEmpty &&
        _address.value.text.isNotEmpty &&
        _birthday.value.text.isNotEmpty;
  }

  /// This function clears the text fields.
  void clearUserInputs() {
    setState(() {
      _firstName.clear();
      _lastName.clear();
      _address.clear();
      _birthday.clear();
    });
  }

  /// This function saves the customer data into the repository with encrypted
  /// shared preferences.
  void saveCustomerData() async {
    CustomerRepository.firstName = _firstName.text;
    CustomerRepository.lastName = _lastName.text;
    CustomerRepository.address = _address.text;
    CustomerRepository.birthday = _birthday.text;
    // saveData() is completed once operations are completed with await.
    await CustomerRepository.saveData();
  }

  /// This function adds a new customer to the database and saves the data to
  /// the repository.
  void addNewCustomer() async {
    // If all the fields are not completed, an alert dialog appears.
    if (!validateUserInputsCustomer()) {
      incompleteForm();
    // If all fields are complete.
    } else {
      // Instantiating customer object with text field values.
      var customer = Customer(Customer.cID, _firstName.value.text,
          _lastName.value.text, _address.value.text, _birthday.value.text);
      // Insert this customer into database.
      await customerDao.insertCustomer(customer);
      // Save customer data to repository.
      saveCustomerData();
      // return to customers main page.
      Navigator.pushNamed(context, "/customersPage");
      // clear inputs in text fields.
      clearUserInputs();
    }
  }

  /// This function updates an existing customer in the database.
  void updateCustomer() {
    // If all text fields are not completed.
    if (!validateUserInputsCustomer()) {
      incompleteForm();
    // If all text fields are completed.
    } else {
      // Instantiating new updated customer with updated values.
      var updatedCustomer = Customer(widget.customer!.customerId, _firstName.value.text,
          _lastName.value.text, _address.value.text, _birthday.value.text);
      // Updating customer using DAO.
      customerDao.updateCustomer(updatedCustomer).then((_) {
        Navigator.pushNamed(context, '/customersPage');
      });
    }
  }

  /// This function is to delete a customer from the database using the DAO.
  void deleteCustomer() async {
    await customerDao.deleteCustomer(widget.customer!);
    Navigator.pushNamed(context, '/customersPage');
    // });
  }

  /// This function is to display an alert dialog if text fields are left empty.
  void incompleteForm() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Warning!"),
        content: const Text("The form is not complete."),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () { Navigator.pop(context); },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Shows the form to add/modify customer details.
            Text("Customer Details", style: TextStyle(fontSize: 30)),
            Container(
              width: 500,
              child: TextField(
                controller: _firstName,
                decoration: InputDecoration(
                  hintText: "First Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: 500,
              child: TextField(
                controller: _lastName,
                decoration: InputDecoration(
                  hintText: "Last Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: 500,
              child: TextField(
                controller: _address,
                decoration: InputDecoration(
                  hintText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              width: 500,
              child: TextField(
                controller: _birthday,
                decoration: InputDecoration(
                  hintText: "Birthday",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Buttons were laid out this way to avoid screen overflow when
            // keyboard displays in portrait mode.
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    child: Text("Save New Customer"),
                    onPressed: addNewCustomer,
                  ),
                  OutlinedButton(
                    child: Text("Update Customer"),
                    onPressed: updateCustomer,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    child: Text("Delete Customer"),
                    onPressed: deleteCustomer,
                  ),
                  ElevatedButton(
                    child: Text("Return to Customer List"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/customersPage');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
