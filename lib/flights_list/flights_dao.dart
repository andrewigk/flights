import 'package:floor/floor.dart';
import 'flights.dart';

@dao
abstract class FlightDao {

  @Query('SELECT * FROM airplanes')
  Future<List<Flight>> getAllAirplanes();

  @Query("SELECT * FROM airplanes WHERE id = :id")
  Stream<Flight?> getAirplaneById(int id);

  @insert
  Future<void> insertAirplane(Flight flight);

  @update
  Future<void> updateAirplane(Flight flight);

  @delete
  Future<void> deleteAirplane(Flight flight);

}