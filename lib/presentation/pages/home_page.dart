import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ledgerx/presentation/controllers/customer_controller.dart';

import '../controllers/entry_controller.dart';
import '../widgets/dashboard_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.find<CustomerController>();
    final entryController = Get.find<EntryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('LedgerX'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await customerController.loadCustomers();
          await entryController.loadEntries();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ড্যাশবোর্ড',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Obx(() => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      DashboardCard(
                        title: 'কাস্টমার',
                        count: customerController.customers.length.toString(),
                        icon: Icons.people,
                        color: Colors.blue,
                        onTap: () => Get.toNamed('/customers'),
                      ),
                      DashboardCard(
                        title: 'এন্ট্রি',
                        count: entryController.entries.length.toString(),
                        icon: Icons.receipt_long,
                        color: Colors.green,
                        onTap: () => Get.toNamed('/entries'),
                      ),
                      DashboardCard(
                        title: 'ক্রেডিট',
                        count: _getCreditsCount(entryController.entries),
                        icon: Icons.add_circle,
                        color: Colors.teal,
                        onTap: () => Get.toNamed('/entries'),
                      ),
                      DashboardCard(
                        title: 'ডেবিট',
                        count: _getDebitsCount(entryController.entries),
                        icon: Icons.remove_circle,
                        color: Colors.orange,
                        onTap: () => Get.toNamed('/entries'),
                      ),
                    ],
                  )),
              const SizedBox(height: 24),
              Text(
                'দ্রুত অ্যাকশন',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ActionChip(
          avatar: const Icon(Icons.person_add),
          label: const Text('কাস্টমার যোগ করুন'),
          onPressed: () => Get.toNamed('/customers'),
        ),
        ActionChip(
          avatar: const Icon(Icons.add),
          label: const Text('এন্ট্রি যোগ করুন'),
          onPressed: () => Get.toNamed('/entries'),
        ),
        ActionChip(
          avatar: const Icon(Icons.upload_file),
          label: const Text('CSV ইম্পোর্ট করুন'),
          onPressed: () => _showImportDialog(context),
        ),
        ActionChip(
          avatar: const Icon(Icons.picture_as_pdf),
          label: const Text('PDF এক্সপোর্ট করুন'),
          onPressed: () => _showExportDialog(context),
        ),
      ],
    );
  }

  String _getCreditsCount(List entries) {
    return entries.where((e) => e.type.name == 'credit').length.toString();
  }

  String _getDebitsCount(List entries) {
    return entries.where((e) => e.type.name == 'debit').length.toString();
  }

  void _showSearch(BuildContext context) {
    Get.snackbar(
      'সার্চ',
      'সার্চ ফিচার শিগগিরই আসছে',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showImportDialog(BuildContext context) {
    Get.snackbar(
      'CSV ইম্পোর্ট',
      'Customers পেজ থেকে CSV ইম্পোর্ট করুন',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showExportDialog(BuildContext context) {
    Get.snackbar(
      'PDF এক্সপোর্ট',
      'Entries পেজ থেকে PDF এক্সপোর্ট করুন',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
