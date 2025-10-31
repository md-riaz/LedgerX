import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final isLoading = false.obs;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'LedgerX',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'লোকাল স্টোর লেজার',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'ইউজারনেম',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'পাসওয়ার্ড',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(
                    usernameController.text,
                    passwordController.text,
                    isLoading,
                  ),
                ),
                const SizedBox(height: 32),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading.value
                            ? null
                            : () => _handleLogin(
                                  usernameController.text,
                                  passwordController.text,
                                  isLoading,
                                ),
                        child: isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('লগইন'),
                      ),
                    )),
                const SizedBox(height: 16),
                FutureBuilder<bool>(
                  future: controller.hasAnyUser(),
                  builder: (context, snapshot) {
                    if (snapshot.data == false) {
                      return TextButton(
                        onPressed: () => _showRegisterDialog(context),
                        child: const Text('প্রথম ইউজার তৈরি করুন'),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(
    String username,
    String password,
    RxBool isLoading,
  ) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'ত্রুটি',
        'ইউজারনেম ও পাসওয়ার্ড লিখুন',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    final success = await controller.login(username, password);
    isLoading.value = false;

    if (success) {
      Get.offAllNamed('/');
    } else {
      Get.snackbar(
        'ত্রুটি',
        'ইউজারনেম বা পাসওয়ার্ড সঠিক নয়',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showRegisterDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('প্রথম ইউজার তৈরি করুন'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'ইউজারনেম',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'পাসওয়ার্ড',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'কনফার্ম পাসওয়ার্ড',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (usernameController.text.isEmpty ||
                  passwordController.text.isEmpty) {
                Get.snackbar(
                  'ত্রুটি',
                  'সব ঘর পূরণ করুন',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              if (passwordController.text != confirmPasswordController.text) {
                Get.snackbar(
                  'ত্রুটি',
                  'পাসওয়ার্ড মিলছে না',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              final success = await controller.register(
                usernameController.text,
                passwordController.text,
              );

              if (success) {
                Get.back();
                Get.offAllNamed('/');
              } else {
                Get.snackbar(
                  'ত্রুটি',
                  'ইউজার তৈরি করা যায়নি',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('তৈরি করুন'),
          ),
        ],
      ),
    );
  }
}
