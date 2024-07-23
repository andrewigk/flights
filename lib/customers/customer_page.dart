import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'customer.dart';
import 'customer_dao.dart';


class CustomerPage extends StatefulWidget {
  // const CustomerPage({super.key, required this.title});
  // final String title;

  @override
  State<StatefulWidget> createState() {
    return CustomerState();
  }
}

class CustomerState extends State<CustomerPage> {
  late TextEditingController _controller;
  var listCustomers = <Customer>[];
  late CustomerDAO customerDAO;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget CustomerList() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Customer List', style: TextStyle(fontSize: 30)),
          TextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Type Here",
                  border: OutlineInputBorder(),
                  labelText: "Enter a customer"
              )
          ),

          ElevatedButton(child: Text('Add Customer'),
              onPressed: () {
                Navigator.pushNamed(context, "/addCustomersPage");
              })
        ],
      ),
    );
  }

  Widget DetailsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Details',
          ),
        ],
      ),
    );
  }

  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if ((width > height) && (width > 720)) {
      return Row(children: [
        Expanded(flex:1, child: CustomerList()),
        Expanded(flex:1, child: DetailsPage())
      ]);
    } else {
      return CustomerList();
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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
        ),
        body: responsiveLayout()
    );
  }
}