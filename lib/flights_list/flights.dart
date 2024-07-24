
import 'package:floor/floor.dart';

@Entity(tableName: 'flights')
class Flight {

  /** static ID used logically */
  static int ID = 1;

  @primaryKey
  final int flightId;
  String destinationCity;
  String departureCity;
  String departureTime;
  String arrivalTime;

  /** Constructor for Flight includes conditional logic to avoid
   * potential primary key issues
   */
  Flight(this.flightId, this.destinationCity, this.departureCity,
      this.departureTime, this.arrivalTime){
      if(flightId >= ID) {
        ID = flightId + 1;
    }
  }

}