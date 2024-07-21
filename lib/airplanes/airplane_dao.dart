
import 'package:floor/floor.dart';
import 'airplane.dart';

@dao
abstract class AirplaneDao {

  @Query('SELECT * FROM airplanes')
  Future<List<Airplane>> getAllAirplanes();

  @Query("SELECT * FROM airplanes WHERE id = :id")
  Stream<Airplane?> getAirplaneById(int id);
  
  @insert
  Future<void> insertAirplane(Airplane airplane);

  @update
  Future<void> updateAirplane(Airplane airplane);

  @delete
  Future<void> deleteAirplane(Airplane airplane);
  
}