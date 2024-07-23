
import 'package:floor/floor.dart';

@Entity(tableName: 'flights')
class Flight {

  static int ID = 1;

  @primaryKey
  final int flightId;
  String destinationCity;
  String departureCity;
  String departureTime;
  String arrivalTime;

  Flight(this.flightId, this.destinationCity, this.departureCity,
      this.departureTime, this.arrivalTime){
      if(flightId >= ID) {
        ID = flightId + 1;
    }
  }

  Map<String, dynamic> toMap() { // MAKE SURE THESE keys MATCH SQL TABLE NAMES!!!!!
    return {
      'flightId': flightId,
      'destinationCity': destinationCity,
      'departureCity': departureCity,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime
    };

  }
}