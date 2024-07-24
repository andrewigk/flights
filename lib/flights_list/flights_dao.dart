import 'package:floor/floor.dart';
import 'flights.dart';

/** DAO defines the DB related functions for CRUD functionality. */
@dao
abstract class FlightDao {

  /** Gets all flights from the DB */
  @Query('SELECT * FROM flights')
  Future<List<Flight>> getAllFlights();

  /** Select a specific flight by its ID */
  @Query("SELECT * FROM flights WHERE id = :id")
  Stream<Flight?> getFlightById(int id);

  /** Inserts a flight into the DB as passed */
  @insert
  Future<void> insertFlight(Flight flight);

  /** Updates a flight in the DB as passed */
  @update
  Future<int> updateFlight(Flight flight);

  /** Deletes a flight in the DB as passed */
  @delete
  Future<int> deleteFlight(Flight flight);

}