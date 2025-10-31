import 'package:get/get.dart';

import '../../data/repositories/entry_repository_impl.dart';
import '../../domain/entities/entry.dart';

class EntryController extends GetxController {
  final EntryRepositoryImpl _repository = EntryRepositoryImpl();

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
      if (selectedCustomerId.value != null) {
        entries.value =
            await _repository.getEntriesByCustomer(selectedCustomerId.value!);
      } else {
        entries.value = await _repository.getAllEntries();
      }
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
    await _repository.createEntry(entry);
    await loadEntries();
    if (closeAfterCreate && Get.isDialogOpen == true) {
      Get.back();
    }
    Get.snackbar(
      'সফল',
      'এন্ট্রি সফলভাবে যোগ হয়েছে',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> updateEntry(Entry entry) async {
    await _repository.updateEntry(entry);
    await loadEntries();
    Get.back();
    Get.snackbar(
      'সফল',
      'এন্ট্রি সফলভাবে হালনাগাদ হয়েছে',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> deleteEntry(int id) async {
    await _repository.deleteEntry(id);
    await loadEntries();
    Get.snackbar(
      'সফল',
      'এন্ট্রি সফলভাবে মুছে ফেলা হয়েছে',
      snackPosition: SnackPosition.BOTTOM,
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
                      (tag) => tag.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }
  }

  Future<void> clearCustomerFilter() async {
    if (selectedCustomerId.value != null) {
      selectedCustomerId.value = null;
      await loadEntries();
    }
  }
}
