import 'package:get/get.dart';

import '../../data/repositories/entry_repository_impl.dart';
import '../../domain/entities/entry.dart';

class EntryController extends GetxController {
  EntryController({
    EntryRepositoryImpl? repository,
    bool enableFeedback = true,
  })  : _repository = repository ?? EntryRepositoryImpl(),
        _enableFeedback = enableFeedback;

  final EntryRepositoryImpl _repository;
  final bool _enableFeedback;

  final RxList<Entry> entries = <Entry>[].obs;
  final RxList<Entry> filteredEntries = <Entry>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final Rx<int?> selectedCustomerId = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      isLoading.value = true;
      final loadedEntries = selectedCustomerId.value != null
          ? await _repository.getEntriesByCustomer(selectedCustomerId.value!)
          : await _repository.getAllEntries();
      entries.assignAll(loadedEntries);
      filteredEntries.assignAll(entries);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadEntriesByCustomer(int customerId) async {
    selectedCustomerId.value = customerId;
    await loadEntries();
  }

  Future<void> createEntry(Entry entry, {bool closeAfterCreate = true}) async {
    final newEntryId = await _repository.createEntry(entry);
    final createdEntry =
        await _repository.getEntryById(newEntryId) ?? entry.copyWith(id: newEntryId);

    if (selectedCustomerId.value == null ||
        selectedCustomerId.value == createdEntry.customerId) {
      entries.add(createdEntry);
      entries.sort((a, b) => b.date.compareTo(a.date));
      entries.refresh();
      searchEntries(searchQuery.value);
    } else {
      await loadEntries();
    }
    if (_enableFeedback && closeAfterCreate && Get.isDialogOpen == true) {
      Get.back();
    }
    _showSuccess(
      'সফল',
      'এন্ট্রি সফলভাবে যোগ হয়েছে',
    );
  }

  Future<void> updateEntry(Entry entry) async {
    await _repository.updateEntry(entry);
    final updatedEntry = entry.id == null
        ? null
        : await _repository.getEntryById(entry.id!);

    if (updatedEntry != null) {
      final matchesFilter = selectedCustomerId.value == null ||
          selectedCustomerId.value == updatedEntry.customerId;
      if (matchesFilter) {
        final index = entries.indexWhere((e) => e.id == updatedEntry.id);
        if (index != -1) {
          entries[index] = updatedEntry;
          entries.sort((a, b) => b.date.compareTo(a.date));
          entries.refresh();
          searchEntries(searchQuery.value);
        } else {
          await loadEntries();
        }
      } else {
        await loadEntries();
      }
    } else {
      await loadEntries();
    }
    if (_enableFeedback && Get.isDialogOpen == true) {
      Get.back();
    }
    _showSuccess(
      'সফল',
      'এন্ট্রি সফলভাবে হালনাগাদ হয়েছে',
    );
  }

  Future<void> deleteEntry(int id) async {
    await _repository.deleteEntry(id);
    final previousLength = entries.length;
    entries.removeWhere((entry) => entry.id == id);
    if (previousLength != entries.length) {
      entries.refresh();
      searchEntries(searchQuery.value);
    } else {
      await loadEntries();
    }
    _showSuccess(
      'সফল',
      'এন্ট্রি সফলভাবে মুছে ফেলা হয়েছে',
    );
  }

  Future<double> getBalance(int customerId) async {
    return await _repository.getBalance(customerId);
  }

  void searchEntries(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredEntries.assignAll(entries);
    } else {
      filteredEntries.value = entries
          .where((entry) =>
              entry.description?.toLowerCase().contains(query.toLowerCase()) ??
              false ||
                  entry.tags.any(
                    (tag) => tag.toLowerCase().contains(query.toLowerCase()),
                  ))
          .toList();
    }
  }

  Future<void> clearCustomerFilter() async {
    if (selectedCustomerId.value != null) {
      selectedCustomerId.value = null;
      await loadEntries();
    }
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
