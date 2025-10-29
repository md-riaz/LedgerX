import 'package:get/get.dart';
import '../../domain/entities/customer.dart';
import '../../data/repositories/customer_repository_impl.dart';

class CustomerController extends GetxController {
  final CustomerRepositoryImpl _repository = CustomerRepositoryImpl();
  
  final RxList<Customer> customers = <Customer>[].obs;
  final RxList<Customer> filteredCustomers = <Customer>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      isLoading.value = true;
      customers.value = await _repository.getAllCustomers();
      filteredCustomers.value = customers;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCustomer(Customer customer) async {
    await _repository.createCustomer(customer);
    await loadCustomers();
    Get.back();
    Get.snackbar(
      'Success',
      'Customer created successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> updateCustomer(Customer customer) async {
    await _repository.updateCustomer(customer);
    await loadCustomers();
    Get.back();
    Get.snackbar(
      'Success',
      'Customer updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> deleteCustomer(int id) async {
    await _repository.deleteCustomer(id);
    await loadCustomers();
    Get.snackbar(
      'Success',
      'Customer deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void searchCustomers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCustomers.value = customers;
    } else {
      filteredCustomers.value = customers
          .where((customer) =>
              customer.name.toLowerCase().contains(query.toLowerCase()) ||
              (customer.phone?.contains(query) ?? false))
          .toList();
    }
  }
}
