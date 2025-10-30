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
      appBar: AppBar(title: const Text('সেটিংস')),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // User Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'অ্যাকাউন্ট',
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
              title:
                  Text(authController.currentUser.value?.username ?? 'ইউজার'),
              subtitle: const Text('লগইন করা হয়েছে'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('পাসওয়ার্ড পরিবর্তন'),
            subtitle: const Text('পাসওয়ার্ড আপডেট করুন'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.to(() => const ChangePasswordPage()),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('লগআউট', style: TextStyle(color: Colors.red)),
            subtitle: const Text('আপনার অ্যাকাউন্ট থেকে সাইন আউট করুন'),
            onTap: () => _confirmLogout(authController),
          ),

          const Divider(),

          // Appearance Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'চেহারা',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Obx(
            () => SwitchListTile(
              title: const Text('ডার্ক মোড'),
              subtitle: const Text('ডার্ক ও লাইট থিম পরিবর্তন করুন'),
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
              'অডিট',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('অডিট লগ'),
            subtitle: const Text('কার্যকলাপের ইতিহাস দেখুন'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.to(() => const AuditLogsPage()),
          ),

          const Divider(),

          // About Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'পরিচিতি',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('LedgerX সম্পর্কে'),
            subtitle: const Text('ভার্সন 1.0.0 - লোকাল স্টোর এডিশন'),
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
        title: const Text('লগআউট'),
        content: const Text('আপনি কি সত্যিই লগআউট করতে চান?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('লগআউট'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('LedgerX সম্পর্কে'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LedgerX',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('ভার্সন 1.0.0 - লোকাল স্টোর এডিশন'),
            SizedBox(height: 16),
            Text(
              'স্থানীয় দোকানের কাস্টমার ক্রেডিট ও ডেবিট পরিচালনার জন্য একটি সহজ অফলাইন লেজার অ্যাপ।',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text('ফিচারসমূহ:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              '• কাস্টমার ম্যানেজমেন্ট\n'
              '• ক্রেডিট ও ডেবিট ট্র্যাকিং\n'
              '• রানিং ব্যালেন্স\n'
              '• সার্চ ও ফিল্টার\n'
              '• পাসওয়ার্ড সুরক্ষা\n'
              '• অফলাইন-ফার্স্ট ডিজাইন',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(), child: const Text('বন্ধ করুন')),
        ],
      ),
    );
  }
}
