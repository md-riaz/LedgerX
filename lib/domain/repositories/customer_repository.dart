import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getAllCustomers();
  Future<Customer?> getCustomerById(int id);
  Future<Customer?> getCustomerByNameInsensitive(String name);
  Future<int> createCustomer(Customer customer);
  Future<int> updateCustomer(Customer customer);
  Future<int> deleteCustomer(int id);
  Future<List<Customer>> searchCustomers(String query);
}
