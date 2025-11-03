import 'dart:math';

import 'package:flutter/foundation.dart';
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

  static final RegExp _whitespaceRegex = RegExp(r'\s+');
  static final RegExp _nonAlphaNumericRegex =
      RegExp(r'[^a-z0-9\u0980-\u09FF ]');

  final RxList<Customer> customers = <Customer>[].obs;
  final RxList<Customer> filteredCustomers = <Customer>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  Customer? getCustomerFromCache(int id) {
    for (final customer in customers) {
      if (customer.id == id) {
        return customer;
      }
    }
    return null;
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
    final createdCustomer = await _repository.getCustomerById(newCustomerId) ??
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

    final normalizedName = _normalizeName(trimmedName);
    for (final customer in customers) {
      if (_normalizeName(customer.name) == normalizedName) {
        return customer;
      }
    }

    final repositoryCustomer =
        await _repository.getCustomerByNameInsensitive(trimmedName);
    if (repositoryCustomer == null) {
      return null;
    }

    if (_normalizeName(repositoryCustomer.name) != normalizedName) {
      return null;
    }

    return repositoryCustomer;
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
    final normalizedTarget = _normalizeName(name);
    final existingCustomer = await findCustomerByName(name);
    if (existingCustomer != null) {
      _showWarning(
        'ডুপ্লিকেট কাস্টমার',
        'এই নামে একটি কাস্টমার ইতিমধ্যেই রয়েছে।',
      );
      return false;
    }

    final similarCustomers = await _findSimilarCustomers(normalizedTarget);
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

  Future<List<Customer>> _findSimilarCustomers(String normalizedTarget) async {
    final customersSnapshot = customers.toList(growable: false);
    if (customersSnapshot.isEmpty) {
      return const [];
    }

    return compute(
      _computeSimilarCustomers,
      _SimilarityComputeInput(
        customers: customersSnapshot,
        normalizedTarget: normalizedTarget,
      ),
    );
  }

  static String _normalizeName(String value) {
    return value
        .toLowerCase()
        .replaceAll(_whitespaceRegex, ' ')
        .replaceAll(_nonAlphaNumericRegex, '')
        .trim();
  }

  static double _stringSimilarity(String a, String b) {
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

  static int _levenshteinDistance(String a, String b) {
    if (identical(a, b)) {
      return 0;
    }
    if (a.isEmpty) {
      return b.length;
    }
    if (b.isEmpty) {
      return a.length;
    }

    if (a.length < b.length) {
      final temp = a;
      a = b;
      b = temp;
    }

    var previousRow = List<int>.generate(b.length + 1, (index) => index);

    for (var i = 0; i < a.length; i++) {
      final currentRow = List<int>.filled(b.length + 1, 0);
      currentRow[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
        currentRow[j + 1] = min(
          min(currentRow[j] + 1, previousRow[j + 1] + 1),
          previousRow[j] + cost,
        );
      }
      previousRow = currentRow;
    }

    return previousRow.last;
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

class _SimilarityComputeInput {
  const _SimilarityComputeInput({
    required this.customers,
    required this.normalizedTarget,
  });

  final List<Customer> customers;
  final String normalizedTarget;
}

List<Customer> _computeSimilarCustomers(_SimilarityComputeInput input) {
  return input.customers.where((customer) {
    final normalizedName = CustomerController._normalizeName(customer.name);
    if (normalizedName == input.normalizedTarget) {
      return false;
    }
    if (normalizedName.contains(input.normalizedTarget) ||
        input.normalizedTarget.contains(normalizedName)) {
      return true;
    }
    return CustomerController._stringSimilarity(
          normalizedName,
          input.normalizedTarget,
        ) >=
        0.8;
  }).toList(growable: false);
}
