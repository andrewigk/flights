import 'package:cst2335_final_project/customers/customer_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../database.dart';
import 'customer.dart';
import 'customer_dao.dart';
import 'customer_add.dart';

/// This is the class that displays the main customer page.
class CustomerPage extends StatefulWidget {
  /// For accessing database.
  final ApplicationDatabase database;
  /// Constructs a CustomerPage with this database.
  CustomerPage({required this.database});

  @override
  State<CustomerPage> createState() => CustomerState(customerDao: database.customerDao, database: database);
}

class CustomerState extends State<CustomerPage> {
  /// Creates a CustomerState instance with a customerDao and this database.
  CustomerState({required this.customerDao, required this.database});
  /// Declaring data access object for customer.
  late CustomerDao customerDao;
  /// Declaring database instance.
  late ApplicationDatabase database;
  /// List to hold an array of customers.
  List<Customer> listCustomers = [];
  /// The current selected customer.
  Customer? selectedCustomer = null;

  @override
  void initState() {
    super.initState();
    // Using DAO to get all customers from database.
    customerDao = database.customerDao;
    customerDao.getAllCustomers().then((allCustomersList) {
      setState(() {
        listCustomers.addAll(allCustomersList);
      });
    });

    // Snackbar to welcome user.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome to the customer list.'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// This method shows a dialog to choose previous customer data or start with blank form.
  Future<void> copyCustomer() async {
    // Ensure data is loaded before showing dialog.
    await CustomerRepository.loadData();
    // Dialog box asking user if they want to use the previously added customer.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Use Previous Customer Data"),
          content: Text("Do you want to use the previously created customer data?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Navigates to the CustomerAdd class/page and includes database
                    // and customer saved in repository.
                    builder: (context) => CustomerAdd(
                      database: database,
                      customer: Customer(
                        Customer.cID,
                        CustomerRepository.firstName,
                        CustomerRepository.lastName,
                        CustomerRepository.address,
                        CustomerRepository.birthday,
                      ),
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              child: Text("No"),
              onPressed: () {
                Navigator.push(
                  context,
                  // Pass database object to CustomerAdd page.
                  MaterialPageRoute(
                    builder: (context) => CustomerAdd(database: database),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Function to show an alert dialog with instructions on how to use the page.
  void instructionsAction() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Page Instructions'),
          content: Text(
             '1. Use the Add Customer button to add a new customer.\n'
             '2. Tap on a customer to view details.\n'
             '3. Use the Update or Delete button to modify an existing customer.'
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Widget that builds the list of customers in the database and displays it.
  Widget CustomerList(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            child: Text('Add Customer'),
            // Adding a customer will prompt user if previous information wants
            // to be used via copyCustomer() function.
            onPressed: () {
              copyCustomer();
            },
          ),
          // What appears if the database is empty.
          if (listCustomers.isEmpty)
            Text("There are no entries in the customer list.")
          else
            // What appears if there are entries in database.
            Expanded(
              child: Column(
                children: [
                  // This is a padded row for the headers.
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
                  // List of customers using ListView.builder.
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
                          // Clicking on customer object.
                          onTap: () async {
                            setState(() {
                              selectedCustomer = listCustomers[rowNumber];
                            });
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

  /// Widget that shows the details of each customer.
  Widget DetailsPage() {
    // If no customer is selected.
    if (selectedCustomer == null) {
      return Center(
        child: Text("Select a customer to see the details."),
      );
    // If a customer is selected, it shows the all the entered details of the customer.
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
                // Clicking update or delete navigates to CustomerAdd page with
                // selected customer and database objects.
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerAdd(
                        database: database,
                        customer: selectedCustomer,
                      ),
                    ),
                  );
                }),
            ElevatedButton(
              child: Text("Go Back."),
              onPressed: () {
                Navigator.pushNamed(context, "/customersPage");
              },
            )
          ],
        ),
      );
    }
  }

  /// This adapts the layout according to the device screen.
  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    // Landscape mode
    if ((width > height) && (width > 720)) {
      return Row(children: [
        Expanded(flex: 1, child: CustomerList(context)),
        Expanded(flex: 1, child: DetailsPage())
      ]);
    // Portrait mode
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Customer List"),
        actions: <Widget>[
          IconButton( // This button is for instructions.
            icon: Icon(Icons.info_outline),
            onPressed: instructionsAction,
          )
        ],
        leading: IconButton( // This button goes back to main page.
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
      body: responsiveLayout(),
    );
  }
}
