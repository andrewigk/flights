import 'package:floor/floor.dart';
import 'flights.dart';

@dao
abstract class FlightDao {

  @Query('SELECT * FROM flights')
  Future<List<Flight>> getAllFlights();

  @Query("SELECT * FROM flights WHERE id = :id")
  Stream<Flight?> getFlightById(int id);

  @insert
  Future<void> insertFlight(Flight flight);

  @update
  Future<int> updateFlight(Flight flight);

  @delete
  Future<int> deleteFlight(Flight flight);

}