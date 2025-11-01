import 'package:get/get.dart';
import 'package:ledgerx/data/repositories/customer_repository_impl.dart';
import 'package:ledgerx/domain/entities/customer.dart';

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
      if (searchQuery.value.isEmpty) {
        filteredCustomers.assignAll(customers);
      } else {
        searchCustomers(searchQuery.value);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCustomer(Customer customer,
      {bool closeAfterCreate = true}) async {
    await _repository.createCustomer(customer);
    await loadCustomers();
    if (closeAfterCreate && Get.isDialogOpen == true) {
      Get.back();
    }
    Get.snackbar(
      'সফল',
      'কাস্টমার সফলভাবে যোগ হয়েছে',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> updateCustomer(Customer customer) async {
    await _repository.updateCustomer(customer);
    await loadCustomers();
    Get.back();
    Get.snackbar(
      'সফল',
      'কাস্টমার সফলভাবে হালনাগাদ হয়েছে',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> deleteCustomer(int id) async {
    await _repository.deleteCustomer(id);
    await loadCustomers();
    Get.snackbar(
      'সফল',
      'কাস্টমার সফলভাবে মুছে ফেলা হয়েছে',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void searchCustomers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCustomers.assignAll(customers);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredCustomers.value = customers.where((customer) {
        final nameMatch = customer.name.toLowerCase().contains(lowerQuery);
        final phoneMatch =
            customer.phone?.toLowerCase().contains(lowerQuery) ?? false;
        final addressMatch =
            customer.address?.toLowerCase().contains(lowerQuery) ?? false;
        final notesMatch =
            customer.notes?.toLowerCase().contains(lowerQuery) ?? false;
        return nameMatch || phoneMatch || addressMatch || notesMatch;
      }).toList();
    }
  }

  Future<Customer?> findCustomerByName(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return null;
    }

    final lowerName = trimmedName.toLowerCase();
    for (final customer in customers) {
      if (customer.name.toLowerCase() == lowerName) {
        return customer;
      }
    }

    await loadCustomers();

    for (final customer in customers) {
      if (customer.name.toLowerCase() == lowerName) {
        return customer;
      }
    }

    return null;
  }

  Future<Customer> createCustomerSilently(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError('Customer name cannot be empty');
    }

    final existingCustomer = await findCustomerByName(trimmedName);
    if (existingCustomer != null) {
      return existingCustomer;
    }

    final newCustomer = Customer(name: trimmedName);
    final id = await _repository.createCustomer(newCustomer);
    final createdCustomer = newCustomer.copyWith(id: id);

    await loadCustomers();

    for (final customer in customers) {
      if (customer.id == id) {
        return customer;
      }
    }

    return createdCustomer;
  }
}
