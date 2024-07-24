import 'package:floor/floor.dart';

@Entity(tableName: 'customers')
class Customer {
  static int cID = 1;

  @primaryKey //unique ID numbers
  final int customerId;
  String firstName;
  String lastName;
  String address;
  String birthday;


  Customer(this.customerId, this.firstName, this.lastName, this.address, this.birthday) {
    if(customerId>=cID) // from database
      cID = customerId + 1; // ID will always be 1 more than biggest id in database.
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