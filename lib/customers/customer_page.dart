import 'package:cst2335_final_project/customers/customer_repository.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../database.dart';
import 'customer.dart';
import 'customer_dao.dart';
import 'customer_add.dart';


class CustomerPage extends StatefulWidget {
  // const CustomerPage({super.key, required this.title});
  // final String title;
  final ApplicationDatabase database;

  CustomerPage({required this.database});

  @override
  State<CustomerPage> createState() => CustomerState(customerDao: database.customerDao, database: database);
}

class CustomerState extends State<CustomerPage> {

  CustomerState({required this.customerDao, required this.database});

  late CustomerDao customerDao;
  late ApplicationDatabase database;

  List <Customer> listCustomers = [];


  Customer? selectedCustomer = null;

  @override
  void initState() {
    super.initState();
    customerDao = database.customerDao;
    customerDao.getAllCustomers().then((allCustomersList) {
      setState(() {
        listCustomers.addAll(allCustomersList);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget CustomerList(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            child: Text('Add Customer'),
            onPressed: () {
              Navigator.pushNamed(context, "/addCustomersPage");
            },
          ),
          if (listCustomers.isEmpty)
            Text("There are no entries in the customer list.")
          else
            Expanded(
              child: Column(
                children: [
                  // Header row
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'First Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Last Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  // List of customers
                  Expanded(
                    child: ListView.builder(
                      itemCount: listCustomers.length,
                      itemBuilder: (context, rowNumber) {
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(listCustomers[rowNumber].firstName),
                                Text(listCustomers[rowNumber].lastName),
                              ],
                            ),
                          ),
                          onTap: () async {

                            setState(() {
                              selectedCustomer = listCustomers[rowNumber];

                            });
                            // EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
                            // await prefs.setString('selectedCustomerId', selectedCustomer!.customerId.toString());

                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }


  Widget DetailsPage() {
    if (selectedCustomer == null) {
      return Center(
        child: Text("Select a customer to see the details."),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("First Name: ${selectedCustomer!.firstName}"),
            Text("Last Name: ${selectedCustomer!.lastName}"),
            Text("Address: ${selectedCustomer!.address}"),
            Text("Birthday: ${selectedCustomer!.birthday}"),
            ElevatedButton(
                child: Text("Update or Delete"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerAdd(
                        database:database,
                        customer: selectedCustomer
                      )
                    )
                  );
                  // CustomerRepository.firstName = selectedCustomer!.firstName;
                  // CustomerRepository.lastName = selectedCustomer!.lastName;
                  // CustomerRepository.address = selectedCustomer!.address;
                  // CustomerRepository.birthday = selectedCustomer!.birthday;
                  // CustomerRepository.saveData();
                  // Navigator.pushNamed(context, "/addCustomersPage");

                }
            ),
            ElevatedButton(
              child: Text("Go Back."),
              onPressed: () {
                Navigator.pushNamed(context, "/customersPage");
              }
            )
          ],
        ),
      );
    }
  }

  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      return Row(children: [
        Expanded(flex:1, child: CustomerList(context)),
        Expanded(flex:1, child: DetailsPage())
      ]);
    } else {
      if (selectedCustomer == null)
        return CustomerList(context);
      else
        return DetailsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Customer List")
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
        ),
        body: responsiveLayout()
    );
  }
}