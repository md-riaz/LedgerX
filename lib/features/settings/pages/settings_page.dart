import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ledgerx/features/auth/controllers/auth_controller.dart';
import 'package:ledgerx/features/auth/pages/change_password_page.dart';
import 'package:ledgerx/presentation/controllers/theme_controller.dart';
import 'package:ledgerx/presentation/pages/audit_logs_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // User Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Obx(
            () => ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(authController.currentUser.value?.username ?? 'User'),
              subtitle: const Text('Logged in'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            subtitle: const Text('Update your password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.to(() => const ChangePasswordPage()),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Sign out from your account'),
            onTap: () => _confirmLogout(authController),
          ),

          const Divider(),

          // Appearance Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Obx(
            () => SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Toggle dark/light theme'),
              value: themeController.themeMode.value == ThemeMode.dark,
              onChanged: (value) {
                themeController.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
              secondary: Icon(
                themeController.themeMode.value == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ),

          const Divider(),

          // Audit Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Audit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Audit Logs'),
            subtitle: const Text('View activity history'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.to(() => const AuditLogsPage()),
          ),

          const Divider(),

          // About Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About LedgerX'),
            subtitle: const Text('Version 1.0.0 - Local Store Edition'),
            onTap: () => _showAboutDialog(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _confirmLogout(AuthController authController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('About LedgerX'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LedgerX',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Version 1.0.0 - Local Store Edition'),
            SizedBox(height: 16),
            Text(
              'A simple offline ledger app for local stores to manage customer credit and debit entries.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              '• Customer management\n'
              '• Credit & Debit tracking\n'
              '• Running balance\n'
              '• Search & filter\n'
              '• Secure with password\n'
              '• Offline-first design',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }
}
