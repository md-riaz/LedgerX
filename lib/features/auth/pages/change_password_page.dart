import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ChangePasswordPage extends GetView<AuthController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final isLoading = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('পাসওয়ার্ড পরিবর্তন'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'আপনার পাসওয়ার্ড পরিবর্তন করুন',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'বর্তমান পাসওয়ার্ড লিখে নতুন পাসওয়ার্ড নির্বাচন করুন',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: oldPasswordController,
              decoration: const InputDecoration(
                labelText: 'বর্তমান পাসওয়ার্ড',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'নতুন পাসওয়ার্ড',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'নতুন পাসওয়ার্ড নিশ্চিত করুন',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading.value
                        ? null
                        : () => _handleChangePassword(
                              oldPasswordController.text,
                              newPasswordController.text,
                              confirmPasswordController.text,
                              isLoading,
                            ),
                    child: isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('পাসওয়ার্ড পরিবর্তন করুন'),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> _handleChangePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
    RxBool isLoading,
  ) async {
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'সব ঘর পূরণ করুন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'ত্রুটি',
        'নতুন পাসওয়ার্ড মিলছে না',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.length < 4) {
      Get.snackbar(
        'ত্রুটি',
        'পাসওয়ার্ড কমপক্ষে ৪ অক্ষরের হতে হবে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    final success = await controller.changePassword(oldPassword, newPassword);
    isLoading.value = false;

    if (success) {
      Get.back();
      Get.snackbar(
        'সফল',
        'পাসওয়ার্ড সফলভাবে পরিবর্তন হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'ত্রুটি',
        'বর্তমান পাসওয়ার্ড সঠিক নয়',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
