import 'package:cst2335_final_project/flights_list/flights.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class FlightRepository {
  static Flight? selectedFlight;

  static String departureCity = "";
  static String destinationCity = "";
  static String departureTime = "";
  static String arrivalTime = "";

  static Future<void> loadData() async {
    final prefs = EncryptedSharedPreferences();
    departureCity = await prefs.getString("departureCity");
    destinationCity = await prefs.getString("destinationCity");
    departureTime = await prefs.getString("departureTime");
    arrivalTime = await prefs.getString("arrivalTime");

  }

  static Future<void> saveData() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString("departureCity", departureCity);
    await prefs.setString("destinationCity", destinationCity);
    await prefs.setString("departureTime", departureTime);
    await prefs.setString("arrivalTime", arrivalTime);
  }
}