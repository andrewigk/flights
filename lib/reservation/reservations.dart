import 'package:floor/floor.dart';

@Entity(tableName: 'reservations')
class Reservations {

  // ID used logically */
  static int rID = 1;

  @primaryKey
  final int reservationId;
  final String reservationTitle;
  String customerName;
  String destinationCity;
  String departureCity;
  String departureTime;
  String arrivalTime;

  Reservations(this.reservationId, this.reservationTitle, this.customerName,
      this.destinationCity, this.departureCity,
      this.departureTime, this.arrivalTime){
    if(reservationId >= rID) {
      rID = reservationId + 1;
    }
  }
}