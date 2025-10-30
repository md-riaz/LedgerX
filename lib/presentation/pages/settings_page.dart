import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ledgerx/data/datasources/ledger_database.dart';
import 'package:ledgerx/presentation/controllers/theme_controller.dart';
import 'package:ledgerx/presentation/pages/audit_logs_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('সেটিংস'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'চেহারা',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Obx(() => SwitchListTile(
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
              )),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'ডেটা',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('ডেটা ব্যাকআপ'),
            subtitle: const Text('ডাটাবেস ফাইল হিসেবে সংরক্ষণ করুন'),
            onTap: () => _backupData(context),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('ডেটা পুনরুদ্ধার'),
            subtitle: const Text('ফাইল থেকে ডাটাবেস ইম্পোর্ট করুন'),
            onTap: () => _restoreData(context),
          ),
          const Divider(),
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
            onTap: () => _showAuditLogs(context),
          ),
          const Divider(),
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
            subtitle: const Text('ভার্সন 1.0.0'),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('লাইসেন্স'),
            subtitle: const Text('লাইসেন্সের তথ্য দেখুন'),
            onTap: () => _showLicenseDialog(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _backupData(BuildContext context) async {
    try {
      final dbPath = await LedgerDatabase().resolvedDatabasePath();

      Get.snackbar(
        'ব্যাকআপ',
        dbPath == null
            ? 'ওয়েবে IndexedDB এর মাধ্যমে ডেটা রাখা হয়। ওয়েবে ব্যাকআপ/এক্সপোর্ট এখনো তৈরি হয়নি।'
            : 'ডাটাবেস পথ: $dbPath\nব্যাকআপ ফাংশন এই ফাইলটি আপনার নির্বাচিত স্থানে কপি করবে।',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'ডেটা ব্যাকআপ করা যায়নি: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _restoreData(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
      );

      if (result != null) {
        Get.snackbar(
          'রিস্টোর',
          'রিস্টোর ফাংশন নির্বাচিত ফাইল দিয়ে বর্তমান ডাটাবেস প্রতিস্থাপন করবে।',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'ডেটা রিস্টোর করা যায়নি: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showAuditLogs(BuildContext context) {
    Get.to(() => const AuditLogsPage());
  }

  void _showAboutDialog(BuildContext context) {
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
            Text('ভার্সন 1.0.0'),
            SizedBox(height: 16),
            Text(
              'একটি Flutter অফলাইন-ফার্স্ট লেজার অ্যাপ যেটিতে রয়েছে:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• GetX স্টেট ম্যানেজমেন্ট\n'
              '• Drift-সমর্থিত SQLite স্টোরেজ ও হ্যাশড ক্রেডেনশিয়াল\n'
              '• কাস্টমার ও এন্ট্রি ম্যানেজমেন্ট\n'
              '• CSV ইম্পোর্ট/এক্সপোর্ট\n'
              '• PDF জেনারেশন\n'
              '• লোকাল নোটিফিকেশন\n'
              '• ব্যাকআপ/রিস্টোর\n'
              '• ডার্ক/লাইট থিম\n'
              '• অডিট লগিং\n'
              '• আরও অনেক কিছু...',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('বন্ধ করুন'),
          ),
        ],
      ),
    );
  }

  void _showLicenseDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('লাইসেন্স'),
        content: const SingleChildScrollView(
          child: Text(
            'MIT License\n\n'
            'Copyright (c) 2024 LedgerX\n\n'
            'Permission is hereby granted, free of charge, to any person obtaining a copy '
            'of this software and associated documentation files (the "Software"), to deal '
            'in the Software without restriction, including without limitation the rights '
            'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell '
            'copies of the Software, and to permit persons to whom the Software is '
            'furnished to do so, subject to the following conditions:\n\n'
            'The above copyright notice and this permission notice shall be included in all '
            'copies or substantial portions of the Software.\n\n'
            'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR '
            'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, '
            'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE '
            'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER '
            'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, '
            'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE '
            'SOFTWARE.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('বন্ধ করুন'),
          ),
        ],
      ),
    );
  }
}
