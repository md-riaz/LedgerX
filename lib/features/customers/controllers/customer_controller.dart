import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:ledgerx/data/repositories/customer_repository_impl.dart';
import 'package:ledgerx/domain/entities/customer.dart';

class CustomerController extends GetxController {
  CustomerController({
    CustomerRepositoryImpl? repository,
    bool enableFeedback = true,
  })  : _repository = repository ?? CustomerRepositoryImpl(),
        _enableFeedback = enableFeedback;

  final CustomerRepositoryImpl _repository;
  final bool _enableFeedback;

  final RxList<Customer> customers = <Customer>[].obs;
  final RxList<Customer> filteredCustomers = <Customer>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  Customer? _findCustomerInCacheByName(String lowerName) {
    return customers.firstWhereOrNull(
      (customer) => customer.name.toLowerCase() == lowerName,
    );
  }

  Customer? getCustomerFromCache(int id) {
    return customers.firstWhereOrNull((customer) => customer.id == id);
  }

  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      isLoading.value = true;
      final allCustomers = await _repository.getAllCustomers();
      customers.assignAll(allCustomers);
      if (searchQuery.value.isEmpty) {
        filteredCustomers.assignAll(customers);
      } else {
        searchCustomers(searchQuery.value);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCustomer(
    Customer customer, {
    bool closeAfterCreate = true,
  }) async {
    final newCustomerId = await _repository.createCustomer(customer);
    final createdCustomer =
        await _repository.getCustomerById(newCustomerId) ??
            customer.copyWith(id: newCustomerId);

    customers.add(createdCustomer);
    customers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    customers.refresh();
    searchCustomers(searchQuery.value);

    if (_enableFeedback && closeAfterCreate && Get.isDialogOpen == true) {
      Get.back();
    }
    _showSuccess(
      'সফল',
      'কাস্টমার সফলভাবে যোগ হয়েছে',
    );
  }

  Future<void> updateCustomer(Customer customer) async {
    await _repository.updateCustomer(customer);
    final updatedCustomer = customer.id == null
        ? null
        : await _repository.getCustomerById(customer.id!);

    if (updatedCustomer != null) {
      final index = customers.indexWhere((c) => c.id == updatedCustomer.id);
      if (index != -1) {
        customers[index] = updatedCustomer;
        customers.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        customers.refresh();
        searchCustomers(searchQuery.value);
      } else {
        await loadCustomers();
      }
    } else {
      await loadCustomers();
    }
    if (_enableFeedback && Get.isDialogOpen == true) {
      Get.back();
    }
    _showSuccess(
      'সফল',
      'কাস্টমার সফলভাবে হালনাগাদ হয়েছে',
    );
  }

  Future<void> deleteCustomer(int id) async {
    await _repository.deleteCustomer(id);
    final previousLength = customers.length;
    customers.removeWhere((customer) => customer.id == id);
    if (previousLength != customers.length) {
      customers.refresh();
      searchCustomers(searchQuery.value);
    } else {
      await loadCustomers();
    }
    _showSuccess(
      'সফল',
      'কাস্টমার সফলভাবে মুছে ফেলা হয়েছে',
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
    final cachedCustomer = _findCustomerInCacheByName(lowerName);
    if (cachedCustomer != null) {
      return cachedCustomer;
    }

    await loadCustomers();

    return _findCustomerInCacheByName(lowerName);
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
    final createdCustomer =
        await _repository.getCustomerById(id) ?? newCustomer.copyWith(id: id);

    customers.add(createdCustomer);

    customers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    customers.refresh();
    searchCustomers(searchQuery.value);

    return createdCustomer;
  }

  void _showSuccess(String title, String message) {
    if (!_enableFeedback || Get.testMode) {
      return;
    }
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
