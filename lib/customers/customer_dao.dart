import 'package:floor/floor.dart';
import 'Customer.dart';

@dao
abstract class CustomerDAO {
  @insert
  Future<void> insertItem(Customer itm);

  @delete
  Future<int> deleteItem(Customer itm);

  @Query('SELECT * FROM CustomerFloor;')
  Future<List<Customer>> getAllItems();

  @update
  Future<int> updateItem(Customer itm);
}