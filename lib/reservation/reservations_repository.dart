import 'package:cst2335_final_project/reservation/reservations.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class ReservationRepository {
  /** Variables representing the attributes of a reservation. */
  static Reservation? selectedReservation;
  static String departureCity = "";
  static String destinationCity = "";
  static String departureTime = "";
  static String arrivalTime = "";

  /** Asynchronously retrieves data from encrypted shared preferences and populates the fields. */
  static Future<void> loadData() async {
    final prefs = EncryptedSharedPreferences();
    departureCity = await prefs.getString("departureCity");
    destinationCity = await prefs.getString("destinationCity");
    departureTime = await prefs.getString("departureTime");
    arrivalTime = await prefs.getString("arrivalTime");
  }

  /** Asynchronously stores the current field values into encrypted shared preferences. */
  static Future<void> saveData() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString("departureCity", departureCity);
    await prefs.setString("destinationCity", destinationCity);
    await prefs.setString("departureTime", departureTime);
    await prefs.setString("arrivalTime", arrivalTime);
  }
}
