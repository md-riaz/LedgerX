import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ledgerx/domain/entities/customer.dart';
import 'package:ledgerx/features/customers/controllers/customer_controller.dart';
import 'package:ledgerx/utils/io_stub.dart'
    if (dart.library.io) 'dart:io'
    as io;

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('কাস্টমার'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => _importCSV(controller),
            tooltip: 'CSV ইম্পোর্ট',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportCSV(controller),
            tooltip: 'CSV এক্সপোর্ট',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const maxContentWidth = 900.0;
          final horizontalPadding = math.max(
            16.0,
            (constraints.maxWidth - maxContentWidth) / 2,
          );

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  8,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: maxContentWidth),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'কাস্টমার সার্চ করুন...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: controller.searchCustomers,
                  ),
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
                            'কোনো কাস্টমার পাওয়া যায়নি',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredCustomers.length,
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      24,
                    ),
                    itemBuilder: (context, index) {
                      final customer = controller.filteredCustomers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(customer.name[0].toUpperCase()),
                          ),
                          title: Text(customer.name),
                          subtitle: Text(
                            customer.phone ??
                                customer.address ??
                                customer.notes ??
                                'অতিরিক্ত তথ্য নেই',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmDelete(context, controller, customer),
                          ),
                          onTap: () => _showCustomerDetails(
                            context,
                            controller,
                            customer,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCustomerDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCustomerDialog(
    BuildContext context,
    CustomerController controller,
  ) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final notesController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('কাস্টমার যোগ করুন'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'নাম *',
                  hintText: 'কাস্টমারের নাম লিখুন',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'ফোন',
                  hintText: 'ফোন নম্বর লিখুন',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'ঠিকানা',
                  hintText: 'ঠিকানা লিখুন',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'নোট',
                  hintText: 'অতিরিক্ত তথ্য',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () async {
              final colorScheme = Theme.of(context).colorScheme;
              final name = nameController.text.trim();

              if (name.isEmpty) {
                Get.snackbar(
                  'নাম প্রয়োজন',
                  'কাস্টমারের নাম লিখুন',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: colorScheme.error,
                  colorText: colorScheme.onError,
                );
                return;
              }

              final customer = Customer(
                name: name,
                phone: phoneController.text.trim().isEmpty
                    ? null
                    : phoneController.text.trim(),
                address: addressController.text.trim().isEmpty
                    ? null
                    : addressController.text.trim(),
                notes: notesController.text.trim().isEmpty
                    ? null
                    : notesController.text.trim(),
              );

              await controller.createCustomer(customer);
              Get.back();
              Get.snackbar(
                'সফল',
                'কাস্টমার যোগ হয়েছে',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('যোগ করুন'),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(
    BuildContext context,
    CustomerController controller,
    Customer customer,
  ) {
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
                title: const Text('ফোন'),
                subtitle: Text(customer.phone!),
                contentPadding: EdgeInsets.zero,
              ),
            ],
            if (customer.address != null) ...[
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('ঠিকানা'),
                subtitle: Text(customer.address!),
                contentPadding: EdgeInsets.zero,
              ),
            ],
            if (customer.notes != null && customer.notes!.isNotEmpty) ...[
              ListTile(
                leading: const Icon(Icons.note),
                title: const Text('নোট'),
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
                  child: const Text('বন্ধ করুন'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed('/entries', arguments: customer.id);
                  },
                  child: const Text('এন্ট্রি দেখুন'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    CustomerController controller,
    Customer customer,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('কাস্টমার মুছে ফেলুন'),
        content: Text('${customer.name} কাস্টমারকে কি মুছে ফেলতে চান?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteCustomer(customer.id!);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('মুছে ফেলুন'),
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
            'ত্রুটি',
            'CSV ফাইল পড়া যায়নি।',
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
            phoneIndex = headerRow.indexWhere(
              (value) => value.contains('phone'),
            );
            addressIndex = headerRow.indexWhere(
              (value) => value.contains('address'),
            );
            notesIndex = headerRow.indexWhere(
              (value) => value.contains('note'),
            );
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
          'সফল',
          'কাস্টমার সফলভাবে ইম্পোর্ট হয়েছে',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'CSV ইম্পোর্ট ব্যর্থ: ${e.toString()}',
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
        'এক্সপোর্ট সম্পন্ন',
        '${customers.length} জন কাস্টমার $fileName ফাইলে সংরক্ষণ হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'CSV এক্সপোর্ট ব্যর্থ: ${e.toString()}',
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
