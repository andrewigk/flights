import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import '../database.dart';
import 'package:cst2335_final_project/customers/customer.dart';
import 'package:cst2335_final_project/customers/customer_dao.dart';
import 'package:cst2335_final_project/flights_list/flights.dart';
import 'reservation.dart';
import 'package:intl/intl.dart'; // Import for date formatting

/// A page for adding a reservation.
///
/// This page allows users to input reservation details, select a customer and flight,
/// and specify a reservation date and time. It also supports language toggling and provides
/// an info dialog with usage instructions.
class ReservationAddPage extends StatefulWidget {
  /// Creates a [ReservationAddPage] instance.
  ///
  /// Requires a [database] to interact with the application's database.
  /// Optionally, a [reservation] can be passed to edit an existing reservation.
  const ReservationAddPage({
    Key? key,
    required this.database,
    Reservation? reservation,
  }) : super(key: key);

  /// The application's database instance used to fetch and save data.
  final ApplicationDatabase database;

  @override
  _ReservationAddPageState createState() => _ReservationAddPageState();
}

class _ReservationAddPageState extends State<ReservationAddPage> {
  final _formKey = GlobalKey<FormState>();
  String _reservationName = '';
  int? _selectedCustomerId;
  int? _selectedFlightId;
  DateTime? _selectedDateTime; // Change to DateTime type
  String _destination = '';
  String _departureTime = '';
  String _arrivalTime = '';
  EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd'); // Define date format
  final DateFormat _timeFormat = DateFormat('HH:mm'); // Define time format

  bool _isGerman = false; // Flag to handle language change

  @override
  void initState() {
    super.initState();
    // Show a Snackbar when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black38,
          elevation: 0,
          content: Center(
            child: Text(
              _isGerman ? 'Ihre Reservierung platzieren' : 'Place your reservation',
              style: TextStyle(color: Colors.black),
            ),
          ),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isGerman ? 'Reservierung Hinzufügen' : 'Add Reservation'),
        actions: [
          ElevatedButton(
            onPressed: _showInfoDialog,
            child: Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 4),
                Text(_isGerman ? 'Info' : 'Info'),
              ],
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: _toggleLanguage,
            child: Text(_isGerman ? 'EN' : 'DE'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: _isGerman ? 'Reservierungsname' : 'Reservation Name'),
                onSaved: (value) {
                  _reservationName = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _isGerman ? 'Bitte geben Sie einen Reservierungsnamen ein' : 'Please enter a reservation name';
                  }
                  return null;
                },
              ),
              FutureBuilder<List<Customer>>(
                future: widget.database.customerDao.getAllCustomers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final customers = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: _isGerman ? 'Kunden auswählen' : 'Select Customer'),
                    items: customers.map((customer) {
                      return DropdownMenuItem<int>(
                        value: customer.customerId,
                        child: Text(customer.lastName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCustomerId = value;
                      });
                    },
                  );
                },
              ),
              FutureBuilder<List<Flight>>(
                future: widget.database.flightDao.getAllFlights(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final flights = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: _isGerman ? 'Flug auswählen' : 'Select Flight'),
                    items: flights.map((flight) {
                      return DropdownMenuItem<int>(
                        value: flight.flightId,
                        child: Text('${flight.departureCity} to ${flight.destinationCity}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFlightId = value;
                        _destination = flights.firstWhere((flight) => flight.flightId == value).destinationCity;
                        _departureTime = flights.firstWhere((flight) => flight.flightId == value).departureTime;
                        _arrivalTime = flights.firstWhere((flight) => flight.flightId == value).arrivalTime;
                      });
                    },
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: _isGerman ? 'Reservierungsdatum & -zeit' : 'Reservation Date & Time',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDateTime,
                  ),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _selectedDateTime == null
                      ? ''
                      : '${_dateFormat.format(_selectedDateTime!)} ${_timeFormat.format(_selectedDateTime!)}',
                ),
                onSaved: (value) {
                  // Optional: Convert saved date and time back to DateTime if needed
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _isGerman ? 'Bitte wählen Sie ein Reservierungsdatum und eine -zeit aus' : 'Please select a reservation date and time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveReservation,
                child: Text(_isGerman ? 'Reservierung speichern' : 'Save Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Opens a date and time picker dialog to select a reservation date and time.
  ///
  /// The selected date and time are then updated in the state.
  Future<void> _selectDateTime() async {
    final currentDateTime = _selectedDateTime ?? DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDateTime),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  /// Saves the reservation if the form is valid.
  ///
  /// Creates a [Reservation] object with the provided details and saves it to the database.
  void _saveReservation() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final reservation = Reservation(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _reservationName,
        customerId: _selectedCustomerId!,
        flightId: _selectedFlightId!,
        reservationDate: _selectedDateTime != null
            ? '${_dateFormat.format(_selectedDateTime!)} ${_timeFormat.format(_selectedDateTime!)}'
            : '',
        destination: _destination,
        departureTime: _departureTime,
        arrivalTime: _arrivalTime,
      );

      await widget.database.reservationDao.insertReservation(reservation);
      Navigator.pop(context);
    }
  }

  /// Shows an info dialog with instructions on how to use the page.
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isGerman ? 'Information' : 'Info'),
        content: Text(_isGerman
            ? 'Um eine Reservierung hinzuzufügen oder zu aktualisieren, geben Sie bitte den Reservierungsnamen ein, wählen Sie dann den Kunden und den Flug aus dem Dropdown-Menü aus, und geben Sie dann die Uhrzeit und das Datum der Erstellung/Aktualisierung der Reservierung ein.'
            : 'To add a reservation, or update the existing one, please type the reservation name, then select the customer and the flight using the drop down menu, then insert the time and date of the reservation creation/update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_isGerman ? 'Schließen' : 'Close'),
          ),
        ],
      ),
    );
  }

  /// Toggles the language between German and English.
  ///
  /// Updates the `_isGerman` flag and refreshes the page to reflect the language change.
  void _toggleLanguage() {
    setState(() {
      _isGerman = !_isGerman;
    });
  }
}
