import 'package:floor/floor.dart';

@entity
class Customer {
  static int ID = 1;

  @primaryKey //unique ID numbers
  final int customerId;
  final String firstName;
  final String lastName;
  final String address;
  final int birthday;


  Customer(this.customerId, this.firstName, this.lastName, this.address, this.birthday) {
    if(customerId>=ID) // from database
      ID = customerId + 1; // ID will always be 1 more than biggest id in database.
  }

  Map<String, dynamic> toMap() {
    // MAKE SURE THESE keys MATCH SQL TABLE NAMES!!!!!
    return {
      'customerId': customerId,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'birthday': birthday
    };
  }
}