import 'package:floor/floor.dart';

/// This class is the floor database entity to store customer information.
@Entity(tableName: 'customers')
class Customer {
  static int cID = 1;

  @primaryKey //unique ID numbers
  final int customerId;
  String firstName;
  String lastName;
  String address;
  String birthday;

  // Customer constructor
  Customer(this.customerId, this.firstName, this.lastName, this.address, this.birthday) {
    if(customerId>=cID) // From database
      cID = customerId + 1; // ID will always be 1 more than biggest ID in database.
  }
}