import 'package:floor/floor.dart';
import 'customer.dart';

/// Data access object class for Customer.
@dao
abstract class CustomerDao {
  // Gets all customers.
  @Query('SELECT * FROM customers')
  Future<List<Customer>> getAllCustomers();

  // Inserts a customer to database.
  @insert
  Future<void> insertCustomer(Customer customer);

  // Updates an existing customer record.
  @update
  Future<void> updateCustomer(Customer customer);

  // Deletes an existing customer record.
  @delete
  Future<void> deleteCustomer(Customer customer);

}