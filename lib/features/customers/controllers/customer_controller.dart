import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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

  Future<bool> createCustomer(
    Customer customer, {
    bool closeAfterCreate = true,
  }) async {
    final sanitizedCustomer = Customer(
      id: customer.id,
      name: customer.name.trim(),
      phone: _sanitizeOptionalField(customer.phone),
      address: _sanitizeOptionalField(customer.address),
      notes: _sanitizeOptionalField(customer.notes),
      createdAt: customer.createdAt,
      updatedAt: customer.updatedAt,
    );

    if (sanitizedCustomer.name.isEmpty) {
      _showWarning('ত্রুটি', 'কাস্টমারের নাম লিখুন');
      return false;
    }

    final canProceed = await _ensureNoDuplicateOrWarn(sanitizedCustomer.name);
    if (!canProceed) {
      return false;
    }

    final newCustomerId = await _repository.createCustomer(sanitizedCustomer);
    final createdCustomer =
        await _repository.getCustomerById(newCustomerId) ??
            sanitizedCustomer.copyWith(id: newCustomerId);

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
    return true;
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

  Future<bool> _ensureNoDuplicateOrWarn(String name) async {
    final existingCustomer = await findCustomerByName(name);
    if (existingCustomer != null) {
      _showWarning(
        'ডুপ্লিকেট কাস্টমার',
        'এই নামে একটি কাস্টমার ইতিমধ্যেই রয়েছে।',
      );
      return false;
    }

    final similarCustomers = _findSimilarCustomers(name);
    if (similarCustomers.isEmpty || !_enableFeedback) {
      return true;
    }

    final shouldProceed = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('সতর্কতা'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('"$name" এর সাথে মিল থাকা কাস্টমার পাওয়া গেছে।'),
                const SizedBox(height: 12),
                ...similarCustomers
                    .map((customer) => Text('• ${customer.name}')),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('বাতিল'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('তবুও যোগ করুন'),
              ),
            ],
          ),
          barrierDismissible: false,
        ) ??
        false;

    if (!shouldProceed) {
      _showWarning(
        'বাতিল',
        'কাস্টমার তৈরি বাতিল করা হয়েছে।',
      );
    }

    return shouldProceed;
  }

  List<Customer> _findSimilarCustomers(String name) {
    final normalizedTarget = _normalizeName(name);

    return customers.where((customer) {
      final normalizedName = _normalizeName(customer.name);
      if (normalizedName == normalizedTarget) {
        return false;
      }
      if (normalizedName.contains(normalizedTarget) ||
          normalizedTarget.contains(normalizedName)) {
        return true;
      }
      return _stringSimilarity(normalizedName, normalizedTarget) >= 0.8;
    }).toList();
  }

  String _normalizeName(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^a-z0-9\u0980-\u09FF ]'), '')
        .trim();
  }

  double _stringSimilarity(String a, String b) {
    if (a.isEmpty || b.isEmpty) {
      return 0;
    }
    final distance = _levenshteinDistance(a, b);
    final maxLength = max(a.length, b.length);
    if (maxLength == 0) {
      return 1;
    }
    return 1 - (distance / maxLength);
  }

  int _levenshteinDistance(String a, String b) {
    final rows = a.length + 1;
    final cols = b.length + 1;
    final matrix = List.generate(rows, (_) => List<int>.filled(cols, 0));

    for (var i = 0; i < rows; i++) {
      matrix[i][0] = i;
    }
    for (var j = 0; j < cols; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i < rows; i++) {
      for (var j = 1; j < cols; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = min(
          min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1),
          matrix[i - 1][j - 1] + cost,
        );
      }
    }

    return matrix[rows - 1][cols - 1];
  }

  void _showWarning(String title, String message) {
    if (!_enableFeedback || Get.testMode) {
      return;
    }
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade700,
      colorText: Colors.white,
    );
  }

  String? _sanitizeOptionalField(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
