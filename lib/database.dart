import 'dart:async';
import 'package:cst2335_final_project/airplanes/airplane.dart';
import 'package:cst2335_final_project/airplanes/airplane_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'customers/customer.dart';
import 'customers/customer_dao.dart';
import 'flights_list/flights.dart';
import 'flights_list/flights_dao.dart';


part 'database.g.dart';

@Database(version: 1, entities: [Airplane, Flight, Customer])
abstract class ApplicationDatabase extends FloorDatabase {

  // all of our entities will be a table in the same app database (this one)

  AirplaneDao get airplaneDao;
  FlightDao get flightDao;
  CustomerDao get customerDao;
}