import 'package:floor/floor.dart';
import 'reservations.dart';

@dao
abstract class ReservationsDao {
  @Query('SELECT * FROM Reservations')
  Future<List<Reservations>> findAllReservations();

  @insert
  Future<void> insertReservations(Reservations reservations);

  @delete
  Future<void> deleteReservations(Reservations reservations);
}
