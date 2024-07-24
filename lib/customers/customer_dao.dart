import 'package:floor/floor.dart';
import 'customer.dart';


@dao
abstract class CustomerDao {

  @Query('SELECT * FROM customers')
  Future<List<Customer>> getAllCustomers();

  @Query("SELECT * FROM customers WHERE id = :id")
  Stream<Customer?> getAirplaneById(int id);

  @insert
  Future<void> insertCustomer(Customer customer);

  @update
  Future<void> updateCustomer(Customer customer);

  @delete
  Future<void> deleteCustomer(Customer customer);

}