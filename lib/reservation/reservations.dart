import 'package:floor/floor.dart';

@Entity(tableName: 'reservations')
class Reservation {

  static int rID = 1;

  @primaryKey
  final int reservationId;
  final String reservationTitle;
  String customerName;
  String departureCity;
  String destinationCity;
  String departureTime;
  String arrivalTime;

  Reservation(
      this.reservationId,
      this.reservationTitle,
      this.customerName,
      this.departureCity,
      this.destinationCity,
      this.departureTime,
      this.arrivalTime,
      ) {
    if (reservationId >= rID) {
      rID = reservationId + 1;
    }
  }
}
