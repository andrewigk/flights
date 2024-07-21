import 'dart:async';

import 'package:cst2335_final_project/airplanes/airplane.dart';
import 'package:cst2335_final_project/airplanes/airplane_dao.dart';
import 'package:floor/floor.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Airplane])
abstract class ApplicationDatabase extends FloorDatabase {

  // all of our entities will be a table in the same app database (this one)

  AirplaneDao get airplaneDao;
}