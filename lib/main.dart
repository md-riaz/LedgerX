import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

import 'data/datasources/database_helper.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/pages/login_page.dart';
import 'features/customers/controllers/customer_controller.dart';
import 'features/customers/pages/customer_list_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/entry_list_page.dart';
import 'features/settings/pages/settings_page.dart';
import 'presentation/themes/app_theme.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/controllers/entry_controller.dart';

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
    return GetMaterialApp(
      title: 'LedgerX',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      initialBinding: BindingsBuilder(() {
        Get.put(ThemeController());
        Get.put(AuthController());
        Get.put(CustomerController());
        Get.put(EntryController());
      }),
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AuthController());
          }),
        ),
        GetPage(
          name: '/',
          page: () => const HomePage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/customers',
          page: () => const CustomerListPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => CustomerController());
          }),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/entries',
          page: () => const EntryListPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => EntryController());
            Get.lazyPut(() => CustomerController());
          }),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/settings',
          page: () => const SettingsPage(),
          middlewares: [AuthMiddleware()],
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn.value) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
