import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'data/datasources/database_helper.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/pages/login_page.dart';
import 'features/customers/controllers/customer_controller.dart';
import 'features/customers/pages/customer_list_page.dart';
import 'features/settings/pages/settings_page.dart';
import 'presentation/controllers/entry_controller.dart';
import 'presentation/controllers/theme_controller.dart';
import 'presentation/pages/entry_list_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/themes/app_theme.dart';
import 'utils/platform_utils.dart';

const _windowsAppName = 'LedgerX';
const _windowsAppUserModelId = 'com.ledgerx.app';
const _windowsGuid = '5a829a22-59c3-4b8f-a8d5-28c8a4630bd8';

final FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
    PlatformUtils.isWeb ? null : FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tzdata.initializeTimeZones();
  try {
    tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('UTC'));
  }

  // Initialize FFI for desktop platforms
  if (PlatformUtils.isWeb) {
    databaseFactory = createDatabaseFactoryFfiWeb(
      options: SqfliteFfiWebOptions(
        sharedWorkerUri: Uri.parse(
          'assets/packages/sqflite_common_ffi_web/assets/sqflite_sw.js',
        ),
        sqlite3WasmUri: Uri.parse(
          'assets/packages/sqflite_common_ffi_web/assets/sqlite3.wasm',
        ),
      ),
    );
  } else if (PlatformUtils.isDesktop) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize database
  await DatabaseHelper.instance.database;

  if (PlatformUtils.isWeb) {
    debugPrint(
        'LedgerX: Local notifications are not supported on the web yet.');
  } else {
    // Initialize notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
      linux:
          LinuxInitializationSettings(defaultActionName: 'Open notification'),
      windows: WindowsInitializationSettings(
        appName: _windowsAppName,
        appUserModelId: _windowsAppUserModelId,
        guid: _windowsGuid,
      ),
    );

    await flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );
  }

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
