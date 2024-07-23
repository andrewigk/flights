import 'package:cst2335_final_project/airplanes/airplane.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class AirplaneRepository {
  static Airplane? selectedAirplane;
  
  static String airplaneType = "";
  static String numberOfPassengers = "";
  static String maxSpeed = "";
  static String range = "";
  
  static Future<void> loadData() async {
    final prefs = EncryptedSharedPreferences();
    airplaneType = await prefs.getString("airplaneType");
    numberOfPassengers = await prefs.getString("numberOfPassengers");
    maxSpeed = await prefs.getString("maxSpeed");
    range = await prefs.getString("range");
    
  }
  
  static Future<void> saveData() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString("airplaneType", airplaneType);
    await prefs.setString("numberOfPassengers", numberOfPassengers);
    await prefs.setString("maxSpeed", maxSpeed);
    await prefs.setString("range", range);
  }
}