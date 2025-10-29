import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/customer.dart';
import '../controllers/customer_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';

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
                        customer.email ?? customer.phone ?? 'No contact info',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, controller, customer),
                      ),
                      onTap: () => _showCustomerDetails(context, controller, customer),
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

  void _showAddCustomerDialog(BuildContext context, CustomerController controller) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

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
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter email address',
                ),
                keyboardType: TextInputType.emailAddress,
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
                  email: emailController.text.isEmpty ? null : emailController.text,
                  phone: phoneController.text.isEmpty ? null : phoneController.text,
                  address: addressController.text.isEmpty ? null : addressController.text,
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

  void _showCustomerDetails(BuildContext context, CustomerController controller, Customer customer) {
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
                      if (customer.email != null)
                        Text(customer.email!, style: Theme.of(context).textTheme.bodyMedium),
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

  void _confirmDelete(BuildContext context, CustomerController controller, Customer customer) {
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
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final input = file.readAsStringSync();
        final fields = const CsvToListConverter().convert(input);

        if (fields.isEmpty) return;

        // Skip header row if it exists
        int startIndex = 1;
        if (fields[0].any((field) => field.toString().toLowerCase().contains('name'))) {
          startIndex = 1;
        } else {
          startIndex = 0;
        }

        for (int i = startIndex; i < fields.length; i++) {
          final row = fields[i];
          if (row.isNotEmpty) {
            final customer = Customer(
              name: row[0].toString(),
              email: row.length > 1 ? row[1].toString() : null,
              phone: row.length > 2 ? row[2].toString() : null,
              address: row.length > 3 ? row[3].toString() : null,
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
        ['Name', 'Email', 'Phone', 'Address'],
      ];

      for (var customer in customers) {
        rows.add([
          customer.name,
          customer.email ?? '',
          customer.phone ?? '',
          customer.address ?? '',
        ]);
      }

      final csv = const ListToCsvConverter().convert(rows);
      
      Get.snackbar(
        'Export',
        'CSV export will be available soon. Data prepared for ${customers.length} customers.',
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
}
