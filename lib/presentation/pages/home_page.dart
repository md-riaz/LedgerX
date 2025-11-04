import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:ledgerx/features/customers/controllers/customer_controller.dart';
import '../controllers/entry_controller.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/responsive_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const double _dashboardContentMaxWidth = 1320;
  static const double _dashboardGridSpacing = 16;
  static const double _dashboardCardHeight = 150;
  static const double _tabletBreakpoint = 600;
  static const double _desktopBreakpoint = 900;
  static const double _largeDesktopBreakpoint = 1200;

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'bn_BD',
    symbol: '৳',
    decimalDigits: 2,
  );

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
          child: ResponsiveContent(
            maxContentWidth: _dashboardContentMaxWidth,
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
                Obx(
                  () => LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = _calculateDashboardColumns(
                        constraints.maxWidth,
                      );
                      final availableWidth = constraints.maxWidth -
                          (crossAxisCount - 1) * _dashboardGridSpacing;
                      final itemWidth = (availableWidth > 0
                              ? availableWidth
                              : constraints.maxWidth) /
                          crossAxisCount;
                      final aspectRatio = itemWidth / _dashboardCardHeight;

                      final dashboardCards = [
                        DashboardCard(
                          title: 'কাস্টমার',
                          count:
                              customerController.customers.length.toString(),
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
                          title: 'টাকা পাবো',
                          count: _formatAmount(
                            entryController.totalCredit.value,
                          ),
                          icon: Icons.add_circle,
                          color: Colors.teal,
                          onTap: () => Get.toNamed('/entries'),
                        ),
                        DashboardCard(
                          title: 'টাকা দেবো',
                          count: _formatAmount(
                            entryController.totalDebit.value,
                          ),
                          icon: Icons.remove_circle,
                          color: Colors.orange,
                          onTap: () => Get.toNamed('/entries'),
                        ),
                      ];

                      return GridView.builder(
                        itemCount: dashboardCards.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: _dashboardGridSpacing,
                          crossAxisSpacing: _dashboardGridSpacing,
                          childAspectRatio: aspectRatio,
                        ),
                        itemBuilder: (context, index) =>
                            dashboardCards[index],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'দ্রুত অ্যাকশন',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildQuickActions(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = constraints.maxWidth > 480 ? 12.0 : 8.0;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.start,
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
      },
    );
  }

  String _formatAmount(double amount) {
    return _currencyFormatter.format(amount);
  }

  int _calculateDashboardColumns(double maxWidth) {
    if (maxWidth >= _largeDesktopBreakpoint) {
      return 4;
    }
    if (maxWidth >= _desktopBreakpoint) {
      return 3;
    }
    if (maxWidth >= _tabletBreakpoint) {
      return 2;
    }
    return 1;
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
