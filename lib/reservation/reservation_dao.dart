import 'package:floor/floor.dart';
import 'reservation.dart';

@dao
abstract class ReservationDao {
  @Query('SELECT * FROM reservations')
  Future<List<Reservation>> getAllReservations();

  @Query('SELECT * FROM reservations WHERE id = :id')
  Stream<Reservation?> getReservationById(int id);

  @insert
  Future<void> insertReservation(Reservation reservation);

  @delete
  Future<void> deleteReservation(Reservation reservation);
}
