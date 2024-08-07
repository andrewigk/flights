import 'package:floor/floor.dart';

@Entity(tableName: 'reservations')
class Reservation {
  @primaryKey
  final int id;
  final String name;
  final int customerId;
  final int flightId;
  final String reservationDate;
  final String destination;
  final String departureTime;
  final String arrivalTime;

  Reservation({
    required this.id,
    required this.name,
    required this.customerId,
    required this.flightId,
    required this.reservationDate,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
  });
}