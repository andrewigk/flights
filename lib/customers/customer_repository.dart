import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'customer.dart';

/// This class is the repository for encrypted shared preferences.
class CustomerRepository {
  /// Declaring a customer object.
  static Customer? selectedCustomer;
  /// Customer object variables.
  static String firstName = "";
  static String lastName = "";
  static String address = "";
  static String birthday = "";

  /// Method to load data asynchronously.
  static Future<void> loadData() async {
    // Instantiating encrypted shared preferences object.
    var prefs = EncryptedSharedPreferences();
    // Retrieve values from encrypted shared preferences and assigning them.
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

  /// Method to save data to encrypted shared preferences.
  static Future<void> saveData() async {
    var prefs = EncryptedSharedPreferences();
    // Save values to shared preferences.
    await prefs.setString("firstName", firstName);
    await prefs.setString("lastName", lastName);
    await prefs.setString("address", address);
    await prefs.setString("birthday", birthday);
  }
}
