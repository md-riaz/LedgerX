import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ledgerx/data/services/backup_service.dart';
import 'package:ledgerx/presentation/controllers/theme_controller.dart';
import 'package:ledgerx/presentation/pages/settings_page.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupServiceMock extends Mock implements BackupService {
  @override
  Future<String?> backupDatabase() => super.noSuchMethod(
        Invocation.method(#backupDatabase, const []),
        returnValue: Future<String?>.value(null),
        returnValueForMissingStub: Future<String?>.value(null),
      );

  @override
  Future<bool> restoreDatabase() => super.noSuchMethod(
        Invocation.method(#restoreDatabase, const []),
        returnValue: Future<bool>.value(false),
        returnValueForMissingStub: Future<bool>.value(false),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BackupServiceMock backupService;

  setUp(() {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    backupService = BackupServiceMock();
    Get.put<BackupService>(backupService);
    Get.put<ThemeController>(ThemeController());
  });

  tearDown(() {
    Get.reset();
  });

  Future<void> pumpSettingsPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: SettingsPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows success snackbar when backup completes', (tester) async {
    final completer = Completer<String?>();
    when(backupService.backupDatabase()).thenAnswer((_) => completer.future);

    await pumpSettingsPage(tester);

    await tester.tap(find.text('ডেটা ব্যাকআপ'));
    await tester.pump();

    expect(find.text('ডেটা ব্যাকআপ চলছে...'), findsOneWidget);

    completer.complete('/tmp/ledgerx_backup.db');
    await tester.pumpAndSettle();

    expect(find.textContaining('ব্যাকআপ সম্পন্ন হয়েছে'), findsOneWidget);
    verify(backupService.backupDatabase()).called(1);
  });

  testWidgets('shows error snackbar when backup fails', (tester) async {
    final completer = Completer<String?>();
    when(backupService.backupDatabase()).thenAnswer((_) => completer.future);

    await pumpSettingsPage(tester);

    await tester.tap(find.text('ডেটা ব্যাকআপ'));
    await tester.pump();

    expect(find.text('ডেটা ব্যাকআপ চলছে...'), findsOneWidget);

    completer.completeError(
      const BackupServiceException('একটি ত্রুটি ঘটেছে'),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('ডেটা ব্যাকআপ করা যায়নি'), findsOneWidget);
    verify(backupService.backupDatabase()).called(1);
  });

  testWidgets('shows success snackbar when restore completes', (tester) async {
    final completer = Completer<bool>();
    when(backupService.restoreDatabase()).thenAnswer((_) => completer.future);

    await pumpSettingsPage(tester);

    await tester.tap(find.text('ডেটা পুনরুদ্ধার'));
    await tester.pump();

    expect(find.text('ডেটা পুনরুদ্ধার চলছে...'), findsOneWidget);

    completer.complete(true);
    await tester.pumpAndSettle();

    expect(find.text('ডাটাবেস সফলভাবে পুনরুদ্ধার হয়েছে।'), findsOneWidget);
    verify(backupService.restoreDatabase()).called(1);
  });

  testWidgets('shows error snackbar when restore fails', (tester) async {
    final completer = Completer<bool>();
    when(backupService.restoreDatabase()).thenAnswer((_) => completer.future);

    await pumpSettingsPage(tester);

    await tester.tap(find.text('ডেটা পুনরুদ্ধার'));
    await tester.pump();

    expect(find.text('ডেটা পুনরুদ্ধার চলছে...'), findsOneWidget);

    completer.completeError(
      const BackupServiceException('রিস্টোর সম্ভব হয়নি'),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('ডেটা পুনরুদ্ধার ব্যর্থ'), findsOneWidget);
    verify(backupService.restoreDatabase()).called(1);
  });
}
