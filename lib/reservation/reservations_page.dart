import 'package:cst2335_final_project/database.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_reservations_page.dart';
import 'reservations.dart';
import 'reservations_dao.dart';
import 'reservations_repository.dart';

/*
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();

  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  MyApp(this.database);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReservationsPage(database),
    );
  }
}

*/

class ReservationsPage extends StatefulWidget {
  final ApplicationDatabase database;

  ReservationsPage({required this.database});

  @override
//  _ReservationsPageState createState() => _ReservationsPageState();
  State<ReservationsPage> createState() => _ReservationsPageState(reservationsDao: database.reservationsDao, database: database);
}

class _ReservationsPageState extends State<ReservationsPage> {
  _ReservationsPageState({required this.reservationsDao, required this.database});
  final TextEditingController _controller = TextEditingController();
  List<Reservations> _items = [];
  Reservations? _selectedItem;
  late ReservationsDao reservationsDao;
  late ApplicationDatabase database;
  late TextEditingController _reservationTitle;
  late TextEditingController _customerName;
  late TextEditingController _destinationCity;
  late TextEditingController _departureCity;
  late TextEditingController _departureTime;
  late TextEditingController _arrivalTime;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _reservationTitle = TextEditingController();
    _customerName = TextEditingController();
    _destinationCity = TextEditingController();
    _departureCity = TextEditingController();
    _departureTime = TextEditingController();
    _arrivalTime = TextEditingController();
  }

  Future<void> _loadItems() async {
    final items = await widget.database.reservationsDao.findAllReservations();
    setState(() {
      _items = items;
    });
  }

  void _addReservation() async {
    if (_controller.text.isNotEmpty) {
      final newReservations = Reservations(
        Reservations.rID,_reservationTitle.value.text, _customerName.value.text,
          _destinationCity.value.text, _departureCity.value.text,
          _departureTime.value.text, _arrivalTime.value.text);
       reservationsDao.insertReservations(newReservations).then((_) {
        Navigator.pushNamed(context, "/addReservationsPage");
      });
      await widget.database.reservationsDao.insertReservations(newReservations);
      setState(() {
        _items.add(newReservations);
        _controller.clear();
      });
    }
  }

  void _deleteItem(Reservations item) async {
    await widget.database.reservationsDao.deleteReservations(item);
    setState(() {
      _items.remove(item);
      _selectedItem = null;
    });
  }

  void _showDeleteItemDialog(BuildContext context, Reservations item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete this reservation?'),
          content: Text('Are you sure you want to delete this reservation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteItem(item);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget ReservationsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: _addReservation,
              child: Text('Add Reservation'),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  hintText: 'Enter your reservation',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Expanded(
          child: _items.isEmpty
              ? Center(child: Text('There are no reservations in the list'))
              : ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedItem = _items[index];
                  });
                },
                onLongPress: () {
                  _showDeleteItemDialog(context, _items[index]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Reservation number: ${index + 1}'),
                      Text(_items[index].reservationTitle),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget DetailsPage() {
    if (_selectedItem == null) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reservation: ${_selectedItem!.reservationTitle}'),
        Text('ID: ${_selectedItem!.reservationId}'),
        Text('Customer: ${_selectedItem!.customerName}'),
        Text('Departure City: ${_selectedItem!.departureCity}'),
        Text('Destination City: ${_selectedItem!.destinationCity}'),
        Text('Departure Time: ${_selectedItem!.departureTime}'),
        Text('Arrival Time: ${_selectedItem!.arrivalTime}'),
        ElevatedButton(
          onPressed: () {
            _deleteItem(_selectedItem!);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }

  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    if (width > height && width > 600) {
      return Row(
        children: [
          Expanded(flex: 1, child: ReservationsList()),
          Expanded(flex: 1, child: Center(child: DetailsPage())),
        ],
      );
    } else {
      if (_selectedItem != null) {
        return DetailsPage();
      } else {
        return ReservationsList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
        backgroundColor: Color(0xFFD1C4E9),
      ),
      body: responsiveLayout(),
    );
  }
}
