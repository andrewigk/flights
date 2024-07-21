
import 'package:floor/floor.dart';

@Entity(tableName: 'airplanes')
class Airplane {

  @primaryKey
   int? airplaneId;
   String airplaneType;
   int numberOfPassengers;
   int maxSpeed;
   int range;

   Airplane({
     this.airplaneId,
     required this.airplaneType,
     required this.numberOfPassengers,
     required this.maxSpeed,
     required this.range
    });

   Map<String, dynamic> toMap() { // MAKE SURE THESE keys MATCH SQL TABLE NAMES!!!!!
     return {
       'airplaneId': airplaneId,
       'airplaneType': airplaneType,
       'numberOfPassengers': numberOfPassengers,
       'maxSpeed': maxSpeed,
       'range': range
     };

   }
}