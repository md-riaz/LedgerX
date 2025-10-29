import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class KeyboardShortcuts extends StatelessWidget {
  final Widget child;

  const KeyboardShortcuts({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        // Navigation shortcuts
        const SingleActivator(LogicalKeyboardKey.keyH, control: true): () {
          Get.offAllNamed('/');
        },
        const SingleActivator(LogicalKeyboardKey.keyC, control: true, shift: true): () {
          Get.toNamed('/customers');
        },
        const SingleActivator(LogicalKeyboardKey.keyE, control: true, shift: true): () {
          Get.toNamed('/entries');
        },
        const SingleActivator(LogicalKeyboardKey.keyS, control: true, shift: true): () {
          Get.toNamed('/settings');
        },
        
        // Quick actions
        const SingleActivator(LogicalKeyboardKey.keyN, control: true): () {
          // Show add dialog based on current page
          _handleQuickAdd();
        },
        const SingleActivator(LogicalKeyboardKey.keyF, control: true): () {
          // Focus search field
          _handleSearch();
        },
        const SingleActivator(LogicalKeyboardKey.keyT, control: true): () {
          // Toggle theme
          _toggleTheme();
        },
        
        // Help
        const SingleActivator(LogicalKeyboardKey.f1): () {
          _showKeyboardShortcuts();
        },
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }

  void _handleQuickAdd() {
    final currentRoute = Get.currentRoute;
    if (currentRoute == '/customers') {
      // Trigger add customer
      Get.snackbar('Shortcut', 'Add Customer (Ctrl+N)');
    } else if (currentRoute == '/entries') {
      // Trigger add entry
      Get.snackbar('Shortcut', 'Add Entry (Ctrl+N)');
    }
  }

  void _handleSearch() {
    Get.snackbar(
      'Search',
      'Focus search field (Ctrl+F)',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void _toggleTheme() {
    Get.snackbar(
      'Theme',
      'Toggle theme (Ctrl+T)',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  void _showKeyboardShortcuts() {
    Get.dialog(
      AlertDialog(
        title: const Text('Keyboard Shortcuts'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShortcutItem('Navigation'),
              _buildShortcut('Ctrl + H', 'Go to Home'),
              _buildShortcut('Ctrl + Shift + C', 'Go to Customers'),
              _buildShortcut('Ctrl + Shift + E', 'Go to Entries'),
              _buildShortcut('Ctrl + Shift + S', 'Go to Settings'),
              const SizedBox(height: 16),
              _buildShortcutItem('Quick Actions'),
              _buildShortcut('Ctrl + N', 'New Item'),
              _buildShortcut('Ctrl + F', 'Search'),
              _buildShortcut('Ctrl + T', 'Toggle Theme'),
              const SizedBox(height: 16),
              _buildShortcutItem('Help'),
              _buildShortcut('F1', 'Show Shortcuts'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutItem(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildShortcut(String keys, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              keys,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(description),
          ),
        ],
      ),
    );
  }
}
