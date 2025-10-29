import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/entry.dart';
import '../controllers/entry_controller.dart';
import '../controllers/customer_controller.dart';
import '../themes/app_theme.dart';

class EntryListPage extends StatelessWidget {
  const EntryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EntryController>();
    final customerController = Get.find<CustomerController>();

    // Check if a customer ID was passed as argument
    final customerId = Get.arguments as int?;
    if (customerId != null) {
      controller.loadEntriesByCustomer(customerId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportPDF(controller),
            tooltip: 'Export PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search entries...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: controller.searchEntries,
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.selectedCustomerId.value != null) {
                    return FutureBuilder<double>(
                      future: controller
                          .getBalance(controller.selectedCustomerId.value!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final balance = snapshot.data!;
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Balance:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${balance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: balance >= 0
                                          ? AppTheme.creditColor
                                          : AppTheme.debitColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredEntries.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No entries found',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredEntries.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final entry = controller.filteredEntries[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: entry.type == EntryType.credit
                            ? AppTheme.creditColor
                            : AppTheme.debitColor,
                        child: Icon(
                          entry.type == EntryType.credit
                              ? Icons.add
                              : Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        '\$${entry.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: entry.type == EntryType.credit
                              ? AppTheme.creditColor
                              : AppTheme.debitColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (entry.description != null)
                            Text(entry.description!),
                          Text(
                            DateFormat('MMM dd, yyyy').format(entry.date),
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (entry.tags.isNotEmpty)
                            Wrap(
                              spacing: 4,
                              children: entry.tags
                                  .map((tag) => Chip(
                                        label: Text(
                                          tag,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.zero,
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _confirmDelete(context, controller, entry),
                      ),
                      onTap: () => _showEntryDetails(context, entry),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showAddEntryDialog(context, controller, customerController),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEntryDialog(
    BuildContext context,
    EntryController controller,
    CustomerController customerController,
  ) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final tagsController = TextEditingController();
    final selectedType = Rx<EntryType>(EntryType.credit);
    final selectedDate = Rx<DateTime>(DateTime.now());
    final selectedCustomerId = Rx<int?>(controller.selectedCustomerId.value);

    Get.dialog(
      AlertDialog(
        title: const Text('Add Entry'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => DropdownMenu<int>(
                    label: const Text('Customer *'),
                    initialSelection: selectedCustomerId.value,
                    dropdownMenuEntries: customerController.customers
                        .where((customer) => customer.id != null)
                        .map((customer) => DropdownMenuEntry<int>(
                              value: customer.id!,
                              label: customer.name,
                            ))
                        .toList(),
                    onSelected: (value) => selectedCustomerId.value = value,
                  )),
              const SizedBox(height: 16),
              Obx(() => SegmentedButton<EntryType>(
                    segments: const [
                      ButtonSegment(
                        value: EntryType.credit,
                        label: Text('Credit'),
                        icon: Icon(Icons.add),
                      ),
                      ButtonSegment(
                        value: EntryType.debit,
                        label: Text('Debit'),
                        icon: Icon(Icons.remove),
                      ),
                    ],
                    selected: {selectedType.value},
                    onSelectionChanged: (Set<EntryType> newSelection) {
                      selectedType.value = newSelection.first;
                    },
                  )),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  hintText: 'Enter amount',
                  prefixText: '\$ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  hintText: 'Enter tags (comma separated)',
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => ListTile(
                    title: const Text('Date'),
                    subtitle: Text(
                        DateFormat('MMM dd, yyyy').format(selectedDate.value)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        selectedDate.value = date;
                      }
                    },
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty &&
                  selectedCustomerId.value != null) {
                final entry = Entry(
                  customerId: selectedCustomerId.value!,
                  type: selectedType.value,
                  amount: double.tryParse(amountController.text) ?? 0.0,
                  description: descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                  date: selectedDate.value,
                  tags: tagsController.text.isEmpty
                      ? []
                      : tagsController.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList(),
                );
                controller.createEntry(entry);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEntryDetails(BuildContext context, Entry entry) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: entry.type == EntryType.credit
                      ? AppTheme.creditColor
                      : AppTheme.debitColor,
                  child: Icon(
                    entry.type == EntryType.credit ? Icons.add : Icons.remove,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${entry.amount.toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: entry.type == EntryType.credit
                                      ? AppTheme.creditColor
                                      : AppTheme.debitColor,
                                ),
                      ),
                      Text(
                        entry.type.name.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            if (entry.description != null) ...[
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Description'),
                subtitle: Text(entry.description!),
                contentPadding: EdgeInsets.zero,
              ),
            ],
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(entry.date)),
              contentPadding: EdgeInsets.zero,
            ),
            if (entry.tags.isNotEmpty) ...[
              ListTile(
                leading: const Icon(Icons.label),
                title: const Text('Tags'),
                subtitle: Wrap(
                  spacing: 4,
                  children: entry.tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, EntryController controller, Entry entry) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Entry'),
        content: Text(
            'Are you sure you want to delete this entry of \$${entry.amount.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteEntry(entry.id!);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportPDF(EntryController controller) {
    Get.snackbar(
      'Export PDF',
      'PDF export functionality will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
