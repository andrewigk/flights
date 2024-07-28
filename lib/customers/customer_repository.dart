import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'customer.dart';

class CustomerRepository {
  static Customer? selectedCustomer;

  static String firstName = "";
  static String lastName = "";
  static String address = "";
  static String birthday = "";

  static Future<void> loadData() async {
    var prefs = EncryptedSharedPreferences();

    prefs.getString("firstName").then((first) {
      firstName = first;
    });
    prefs.getString("lastName").then((last) {
      lastName = last;
    });
    prefs.getString("address").then((cAddress) {
      address = cAddress;
    });
    prefs.getString("birthday").then((bday) {
      birthday = bday;
    });
  }

  static void saveData() {
    var prefs = EncryptedSharedPreferences();

    prefs.setString("firstName", firstName);
    prefs.setString("lastName", lastName);
    prefs.setString("address", address);
    prefs.setString("birthday", birthday);
  }
}
