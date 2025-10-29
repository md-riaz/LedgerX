import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

import 'data/datasources/database_helper.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/customer_list_page.dart';
import 'presentation/pages/entry_list_page.dart';
import 'presentation/pages/settings_page.dart';
import 'presentation/themes/app_theme.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/widgets/keyboard_shortcuts.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize FFI for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  // Initialize database
  await DatabaseHelper.instance.database;
  
  // Initialize notifications
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettingsIOS = DarwinInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap
    },
  );
  
  runApp(const LedgerXApp());
}

class LedgerXApp extends StatelessWidget {
  const LedgerXApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    
    return Obx(() => KeyboardShortcuts(
      child: GetMaterialApp(
        title: 'LedgerX',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode.value,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const HomePage()),
          GetPage(name: '/customers', page: () => const CustomerListPage()),
          GetPage(name: '/entries', page: () => const EntryListPage()),
          GetPage(name: '/settings', page: () => const SettingsPage()),
        ],
        debugShowCheckedModeBanner: false,
      ),
    ));
  }
}
