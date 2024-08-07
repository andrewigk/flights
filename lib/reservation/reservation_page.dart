import 'package:flutter/material.dart';
import 'package:cst2335_final_project/database.dart';
import 'reservation_add.dart';
import 'reservation.dart';

/// This class displays the main reservation page.
class ReservationPage extends StatefulWidget {
  /// The database object to interact with the reservations.
  final ApplicationDatabase database;

  /// Creates a ReservationPage with the given database.
  const ReservationPage({Key? key, required this.database}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  Reservation? selectedReservation;
  bool isEnglish = true;

  @override
  void initState() {
    super.initState();
    // Show the Snackbar after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black38,
          elevation: 0,
          content: Center(
            child: Text(
              'Welcome to reservation page',
              style: TextStyle(color: Colors.black),
            ),
          ),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  /// Toggles the language between English and German.
  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  /// Shows a dialog with discount information.
  void _showDiscountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEnglish ? 'Discounts Available!' : 'Rabatte verfügbar!'),
          content: Text(isEnglish
              ? 'Enjoy special discounts during July-August period. Don’t miss out on these great deals!'
              : 'Genießen Sie spezielle Rabatte im Zeitraum Juli-August. Verpassen Sie nicht diese großartigen Angebote!'),
          actions: <Widget>[
            ElevatedButton(
              child: Text(isEnglish ? 'Next' : 'Weiter'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationAddPage(database: widget.database)),
                ).then((value) {
                  setState(() {
                    // Refresh the page after adding a reservation
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows an information dialog about how to use the app.
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEnglish ? 'Information' : 'Informationen'),
          content: Text(isEnglish
              ? "To add a new reservation, simply click on 'Add Reservation'. To see the details of an existing reservation, click on the reservation given in the list."
              : "Um eine neue Reservierung hinzuzufügen, klicken Sie einfach auf 'Reservierung hinzufügen'. Um die Details einer bestehenden Reservierung zu sehen, klicken Sie auf die in der Liste angegebene Reservierung."),
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

  /// Shows a confirmation dialog to delete a reservation.
  ///
  /// If the user confirms, the reservation is deleted.
  /// If the user cancels, the dialog is closed without any action.
  void _showDeleteDialog(Reservation reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEnglish ? 'Delete Reservation' : 'Reservierung löschen'),
          content: Text(isEnglish ? 'Are you sure you want to delete this reservation?' : 'Sind Sie sicher, dass Sie diese Reservierung löschen möchten?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text(isEnglish ? 'Cancel' : 'Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(isEnglish ? 'Delete' : 'Löschen'),
              onPressed: () {
                widget.database.reservationDao.deleteReservation(reservation);
                Navigator.of(context).pop();
                setState(() {
                  // Refresh the list after deleting a reservation
                  selectedReservation = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  /// Builds the list of reservations.
  ///
  /// Each list item can be tapped to view details or long-pressed to delete.
  Widget _buildReservationList(BuildContext context, List<Reservation> reservations) {
    return ListView.builder(
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return ListTile(
          title: Text(reservation.name),
          subtitle: Text(isEnglish
              ? 'Customer ID: ${reservation.customerId}, Flight ID: ${reservation.flightId}'
              : 'Kunden-ID: ${reservation.customerId}, Flug-ID: ${reservation.flightId}'),
          onTap: () {
            setState(() {
              selectedReservation = reservation;
            });
          },
          onLongPress: () {
            _showDeleteDialog(reservation);
          },
        );
      },
    );
  }

  /// Widget that shows the details of each reservation.
  ///
  /// If no reservation is selected, prompts the user to select one.
  Widget DetailsPage() {
    // If no reservation is selected.
    if (selectedReservation == null) {
      return Center(
        child: Text(isEnglish ? "Select a reservation to see the details." : "Wählen Sie eine Reservierung aus, um die Details zu sehen."),
      );
      // If a reservation is selected, it shows the all the entered details of the reservation.
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(isEnglish ? "Customer Name: ${selectedReservation!.name}" : "Kundenname: ${selectedReservation!.name}"),
            Text(isEnglish ? "Customer ID: ${selectedReservation!.customerId}" : "Kunden-ID: ${selectedReservation!.customerId}"),
            Text(isEnglish ? "Flight ID: ${selectedReservation!.flightId}" : "Flug-ID: ${selectedReservation!.flightId}"),
            ElevatedButton(
                child: Text(isEnglish ? "Update Reservation" : "Reservierung aktualisieren"),
                // Clicking update or delete navigates to ReservationAdd page with
                // selected reservati on and database objects.
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationAddPage(
                        database: widget.database,
                        reservation: selectedReservation,
                      ),
                    ),
                  ).then((value) {
                    setState(() {
                      // Refresh the page after updating or deleting a reservation
                    });
                  });
                }),
            ElevatedButton(
              child: Text(isEnglish ? "Go Back." : "Zurück."),
              onPressed: () {
                setState(() {
                  selectedReservation = null;
                });
              },
            )
          ],
        ),
      );
    }
  }

  /// Adapts the layout according to the device screen orientation.
  ///
  /// In landscape mode, displays the list and details side by side.
  /// In portrait mode, displays either the list or the details.
  Widget responsiveLayout() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    // Landscape mode
    if ((width > height) && (width > 720)) {
      return Row(children: [
        Expanded(
          flex: 1,
          child: FutureBuilder<List<Reservation>>(
            future: widget.database.reservationDao.getAllReservations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(isEnglish ? 'There are no reservations currently.' : 'Es gibt derzeit keine Reservierungen.'));
              }

              final reservations = snapshot.data!;
              return _buildReservationList(context, reservations);
            },
          ),
        ),
        Expanded(flex: 1, child: DetailsPage())
      ]);
      // Portrait mode
    } else {
      if (selectedReservation == null)
        return FutureBuilder<List<Reservation>>(
          future: widget.database.reservationDao.getAllReservations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(isEnglish ? 'There are no reservations currently.' : 'Es gibt derzeit keine Reservierungen.'));
            }

            final reservations = snapshot.data!;
            return _buildReservationList(context, reservations);
          },
        );
      else
        return DetailsPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.info_outline),
              label: Text('Info'),
              onPressed: _showInfoDialog,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              child: Text(isEnglish ? 'DE' : 'EN'),
              onPressed: _toggleLanguage,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _showDiscountDialog,
              child: Text(isEnglish ? 'Add Reservation' : 'Reservierung hinzufügen'),
            ),
          ),
          Expanded(child: responsiveLayout())
        ],
      ),
    );
  }
}
