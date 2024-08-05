import 'package:floor/floor.dart';
import 'reservations.dart';

/** DAO (Data Access Object) specifies the methods for performing CRUD operations on reservations. */
@dao
abstract class ReservationDao {

  /* Activate this once the Customers are added.
  /** Retrieves all customers from the database. */
  @Query('SELECT * FROM customers')
  Future<List<Reservation>> getAllCustomers();
  */

  /** Retrieves all reservations from the database. */
  @Query('SELECT * FROM reservations')
  Future<List<Reservation>> getAllReservations();

  /** Fetches a reservation from the database based on its ID. */
  @Query("SELECT * FROM reservations WHERE id = :id")
  Stream<Reservation?> getReservationById(int id);

  /** Inserts a new reservation into the database. */
  @insert
  Future<void> insertReservation(Reservation reservation);

  /** Updates an existing reservation in the database. */
  @update
  Future<int> updateReservation(Reservation reservation);

  /** Removes a reservation from the database. */
  @delete
  Future<int> deleteReservation(Reservation reservation);

}
