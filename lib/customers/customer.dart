import 'package:floor/floor.dart';

@entity
class Customer {
  static int ID = 1;

  @primaryKey //unique ID numbers
  final int id;
  final String firstName;
  final String lastName;
  final String address;
  final int birthday;

  Customer(this.id, this.firstName, this.lastName, this.address, this.birthday) {
    if(id>=ID) // from database
      ID = id + 1; // ID will always be 1 more than biggest id in database.
  }
}