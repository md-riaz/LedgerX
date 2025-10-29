import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_controller.dart';
import '../controllers/entry_controller.dart';
import '../widgets/dashboard_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.put(CustomerController());
    final entryController = Get.put(EntryController());

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
                'Dashboard',
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
                        title: 'Customers',
                        count: customerController.customers.length.toString(),
                        icon: Icons.people,
                        color: Colors.blue,
                        onTap: () => Get.toNamed('/customers'),
                      ),
                      DashboardCard(
                        title: 'Entries',
                        count: entryController.entries.length.toString(),
                        icon: Icons.receipt_long,
                        color: Colors.green,
                        onTap: () => Get.toNamed('/entries'),
                      ),
                      DashboardCard(
                        title: 'Credits',
                        count: _getCreditsCount(entryController.entries),
                        icon: Icons.add_circle,
                        color: Colors.teal,
                        onTap: () => Get.toNamed('/entries'),
                      ),
                      DashboardCard(
                        title: 'Debits',
                        count: _getDebitsCount(entryController.entries),
                        icon: Icons.remove_circle,
                        color: Colors.orange,
                        onTap: () => Get.toNamed('/entries'),
                      ),
                    ],
                  )),
              const SizedBox(height: 24),
              Text(
                'Quick Actions',
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
          label: const Text('Add Customer'),
          onPressed: () => Get.toNamed('/customers'),
        ),
        ActionChip(
          avatar: const Icon(Icons.add),
          label: const Text('Add Entry'),
          onPressed: () => Get.toNamed('/entries'),
        ),
        ActionChip(
          avatar: const Icon(Icons.upload_file),
          label: const Text('Import CSV'),
          onPressed: () => _showImportDialog(context),
        ),
        ActionChip(
          avatar: const Icon(Icons.picture_as_pdf),
          label: const Text('Export PDF'),
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
      'Search',
      'Search functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showImportDialog(BuildContext context) {
    Get.snackbar(
      'Import CSV',
      'CSV import functionality available in Customers page',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showExportDialog(BuildContext context) {
    Get.snackbar(
      'Export PDF',
      'PDF export functionality available in Entries page',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
