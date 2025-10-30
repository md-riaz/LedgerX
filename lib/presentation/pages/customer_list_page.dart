import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ledgerx/domain/entities/customer.dart';
import 'package:ledgerx/presentation/controllers/customer_controller.dart';
import 'package:ledgerx/utils/io_stub.dart' if (dart.library.io) 'dart:io'
    as io;

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => _importCSV(controller),
            tooltip: 'Import CSV',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportCSV(controller),
            tooltip: 'Export CSV',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: controller.searchCustomers,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredCustomers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No customers found',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredCustomers.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final customer = controller.filteredCustomers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(customer.name[0].toUpperCase()),
                      ),
                      title: Text(customer.name),
                      subtitle: Text(
                        customer.phone ??
                            customer.address ??
                            customer.notes ??
                            'No additional details',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _confirmDelete(context, controller, customer),
                      ),
                      onTap: () =>
                          _showCustomerDetails(context, controller, customer),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCustomerDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCustomerDialog(
      BuildContext context, CustomerController controller) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final notesController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Customer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter customer name',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter phone number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter address',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Additional information',
                ),
                maxLines: 3,
              ),
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
              if (nameController.text.isNotEmpty) {
                final customer = Customer(
                  name: nameController.text,
                  phone: phoneController.text.isEmpty
                      ? null
                      : phoneController.text,
                  address: addressController.text.isEmpty
                      ? null
                      : addressController.text,
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                );
                controller.createCustomer(customer);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(
      BuildContext context, CustomerController controller, Customer customer) {
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
                  child: Text(
                    customer.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (customer.phone != null)
                        Text(
                          customer.phone!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            if (customer.phone != null) ...[
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Phone'),
                subtitle: Text(customer.phone!),
                contentPadding: EdgeInsets.zero,
              ),
            ],
            if (customer.address != null) ...[
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Address'),
                subtitle: Text(customer.address!),
                contentPadding: EdgeInsets.zero,
              ),
            ],
            if (customer.notes != null && customer.notes!.isNotEmpty) ...[
              ListTile(
                leading: const Icon(Icons.note),
                title: const Text('Notes'),
                subtitle: Text(customer.notes!),
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
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed('/entries', arguments: customer.id);
                  },
                  child: const Text('View Entries'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, CustomerController controller, Customer customer) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Customer'),
        content: Text('Are you sure you want to delete ${customer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteCustomer(customer.id!);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _importCSV(CustomerController controller) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result != null) {
        final file = result.files.single;
        final bytes = await _resolveFileBytes(file);
        if (bytes == null) {
          Get.snackbar(
            'Error',
            'Unable to read CSV file contents.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        final input = utf8.decode(bytes);
        final fields = const CsvToListConverter().convert(input);

        if (fields.isEmpty) return;

        // Skip header row if it exists
        var startIndex = 0;
        var nameIndex = 0;
        var phoneIndex = -1;
        var addressIndex = -1;
        var notesIndex = -1;

        if (fields.isNotEmpty) {
          final headerRow = fields.first
              .map((field) => field.toString().toLowerCase())
              .toList();
          final hasHeader = headerRow.any((value) => value.contains('name'));

          if (hasHeader) {
            startIndex = 1;
            nameIndex = headerRow.indexWhere((value) => value.contains('name'));
            phoneIndex =
                headerRow.indexWhere((value) => value.contains('phone'));
            addressIndex =
                headerRow.indexWhere((value) => value.contains('address'));
            notesIndex =
                headerRow.indexWhere((value) => value.contains('note'));
          } else {
            phoneIndex = fields[0].length > 1 ? 1 : -1;
            addressIndex = fields[0].length > 2 ? 2 : -1;
            notesIndex = fields[0].length > 3 ? 3 : -1;
          }
        }

        for (int i = startIndex; i < fields.length; i++) {
          final row = fields[i];
          if (row.isNotEmpty) {
            final customer = Customer(
              name: row[nameIndex].toString(),
              phone: phoneIndex != -1 && phoneIndex < row.length
                  ? row[phoneIndex].toString()
                  : null,
              address: addressIndex != -1 && addressIndex < row.length
                  ? row[addressIndex].toString()
                  : null,
              notes: notesIndex != -1 && notesIndex < row.length
                  ? row[notesIndex].toString()
                  : null,
            );
            await controller.createCustomer(customer);
          }
        }

        Get.snackbar(
          'Success',
          'Customers imported successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to import CSV: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _exportCSV(CustomerController controller) async {
    try {
      final customers = controller.customers;
      final List<List<dynamic>> rows = [
        ['Name', 'Phone', 'Address', 'Notes'],
      ];

      for (var customer in customers) {
        rows.add([
          customer.name,
          customer.phone ?? '',
          customer.address ?? '',
          customer.notes ?? '',
        ]);
      }

      final csvData = const ListToCsvConverter().convert(rows);
      final fileName =
          'ledgerx_customers_${DateTime.now().toIso8601String().replaceAll(':', '-')}.csv';
      final csvBytes = Uint8List.fromList(utf8.encode(csvData));

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: csvBytes,
        mimeType: MimeType.csv,
      );

      Get.snackbar(
        'Exported',
        'Saved ${customers.length} customers to $fileName',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export CSV: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<Uint8List?> _resolveFileBytes(PlatformFile file) async {
    if (file.bytes != null) {
      return file.bytes;
    }

    final path = file.path;
    if (path == null) {
      return null;
    }

    try {
      final fileBytes = await io.File(path).readAsBytes();
      return Uint8List.fromList(fileBytes);
    } catch (e, s) {
      Get.log('Failed to read file bytes from $path: $e\n$s');
      return null;
    }
  }
}
