import 'package:cst2335_final_project/Reservation/reservations.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class ReservationRepository {
  /** Variables that correspond to the entity attributes */
  static Reservations? selectedReservation;
  static String departureCity = "";
  static String destinationCity = "";
  static String departureTime = "";
  static String arrivalTime = "";

  /** loadData asynchronously loads from the encrypted shared preferences into
   * the fields.
   */
  static Future<void> loadData() async {
    final prefs = EncryptedSharedPreferences();
    departureCity = await prefs.getString("departureCity");
    destinationCity = await prefs.getString("destinationCity");
    departureTime = await prefs.getString("departureTime");
    arrivalTime = await prefs.getString("arrivalTime");

  }

  /** saveData asynchronously saves the fields that are set to the class
   * into the sharedpreferences.
   */
  static Future<void> saveData() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString("departureCity", departureCity);
    await prefs.setString("destinationCity", destinationCity);
    await prefs.setString("departureTime", departureTime);
    await prefs.setString("arrivalTime", arrivalTime);
  }
}