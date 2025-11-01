import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/entry.dart';
import 'package:ledgerx/domain/entities/customer.dart';
import 'package:ledgerx/features/customers/controllers/customer_controller.dart';

import '../controllers/entry_controller.dart';
import '../themes/app_theme.dart';

class EntryListPage extends StatelessWidget {
  const EntryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EntryController>();
    final customerController = Get.find<CustomerController>();

    // Check if a customer ID was passed as argument
    final customerId = Get.arguments as int?;
    if (customerId != null) {
      if (controller.selectedCustomerId.value != customerId) {
        controller.loadEntriesByCustomer(customerId);
      }
    } else {
      controller.clearCustomerFilter();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('এন্ট্রি'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportPDF(controller),
            tooltip: 'PDF এক্সপোর্ট করুন',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _QuickEntryForm(
              entryController: controller,
              customerController: customerController,
              onOpenFullForm: () =>
                  _showAddEntryDialog(context, controller, customerController),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'এন্ট্রি সার্চ করুন...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: controller.searchEntries,
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.selectedCustomerId.value != null) {
                    return FutureBuilder<double>(
                      future: controller.getBalance(
                        controller.selectedCustomerId.value!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final balance = snapshot.data!;
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'ব্যালেন্স:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '৳${balance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: balance >= 0
                                          ? AppTheme.creditColor
                                          : AppTheme.debitColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredEntries.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'কোনো এন্ট্রি পাওয়া যায়নি',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredEntries.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final entry = controller.filteredEntries[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: entry.type == EntryType.credit
                            ? AppTheme.creditColor
                            : AppTheme.debitColor,
                        child: Icon(
                          entry.type == EntryType.credit
                              ? Icons.add
                              : Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        '৳${entry.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: entry.type == EntryType.credit
                              ? AppTheme.creditColor
                              : AppTheme.debitColor,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (entry.description != null)
                            Text(entry.description!),
                          Text(
                            DateFormat('MMM dd, yyyy').format(entry.date),
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (entry.tags.isNotEmpty)
                            Wrap(
                              spacing: 4,
                              children: entry.tags
                                  .map(
                                    (tag) => Chip(
                                      label: Text(
                                        tag,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                    ),
                                  )
                                  .toList(),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _confirmDelete(context, controller, entry),
                      ),
                      onTap: () => _showEntryDetails(context, entry),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _showAddEntryDialog(context, controller, customerController),
        icon: const Icon(Icons.article_outlined),
        label: const Text('বিস্তারিত এন্ট্রি ফর্ম'),
      ),
    );
  }
}

class _QuickEntryForm extends StatefulWidget {
  const _QuickEntryForm({
    required this.entryController,
    required this.customerController,
    required this.onOpenFullForm,
  });

  final EntryController entryController;
  final CustomerController customerController;
  final VoidCallback onOpenFullForm;

  @override
  State<_QuickEntryForm> createState() => _QuickEntryFormState();
}

class _QuickEntryFormState extends State<_QuickEntryForm> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  TextEditingController? _customerTextController;
  Customer? _selectedCustomer;
  String _customerInput = '';
  bool _isProgrammaticCustomerUpdate = false;
  EntryType _selectedType = EntryType.credit;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final initialCustomerId = widget.entryController.selectedCustomerId.value;
    if (initialCustomerId != null) {
      final match = _findCustomerById(
        widget.customerController.customers,
        initialCustomerId,
      );
      if (match != null) {
        _selectedCustomer = match;
        _customerInput = match.name;
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _customerTextController?.dispose();
    super.dispose();
  }

  Customer? _findCustomerById(List<Customer> customers, int id) {
    for (final customer in customers) {
      if (customer.id == id) {
        return customer;
      }
    }
    return null;
  }

  void _updateCustomerText(String text, {Customer? customer}) {
    if (!mounted) return;
    _isProgrammaticCustomerUpdate = true;
    setState(() {
      _selectedCustomer = customer;
      _customerInput = text;
    });
    if (_customerTextController != null &&
        _customerTextController!.text != text) {
      _customerTextController!
        ..text = text
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: text.length),
        );
    }
    _isProgrammaticCustomerUpdate = false;
  }

  void _showError(ColorScheme colorScheme, String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: colorScheme.error,
      colorText: colorScheme.onError,
    );
  }

  Future<void> _submit() async {
    if (_isSaving) return;

    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);
    final colorScheme = Theme.of(context).colorScheme;
    final trimmedName = _customerInput.trim();
    final currentCustomerId = widget.entryController.selectedCustomerId.value;

    if ((currentCustomerId == null || currentCustomerId <= 0) &&
        trimmedName.isEmpty) {
      _showError(colorScheme, 'কাস্টমার নেই', 'প্রথমে কাস্টমার নির্বাচন করুন');
      return;
    }

    if (amount == null || amount <= 0) {
      _showError(colorScheme, 'ভুল পরিমাণ', 'সঠিক টাকার পরিমাণ লিখুন');
      return;
    }

    setState(() => _isSaving = true);

    var targetCustomerId = currentCustomerId;
    Customer? ensuredCustomer = _selectedCustomer;
    var shouldResetFields = false;

    try {
      if (targetCustomerId == null || targetCustomerId <= 0) {
        ensuredCustomer = await widget.customerController
            .findCustomerByName(trimmedName);
        if (ensuredCustomer == null) {
          ensuredCustomer = await widget.customerController
              .createCustomerSilently(trimmedName);
        }

        targetCustomerId = ensuredCustomer.id;
        if (targetCustomerId != null) {
          widget.entryController.selectedCustomerId.value = targetCustomerId;
          _updateCustomerText(ensuredCustomer.name, customer: ensuredCustomer);
        }
      }

      if (targetCustomerId == null) {
        throw ArgumentError('কাস্টমার নির্বাচন করা সম্ভব হয়নি');
      }

      final entry = Entry(
        customerId: targetCustomerId,
        type: _selectedType,
        amount: amount,
        description: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        date: DateTime.now(),
        tags: const [],
      );

      await widget.entryController.createEntry(entry, closeAfterCreate: false);
      shouldResetFields = true;
    } on ArgumentError catch (error) {
      _showError(colorScheme, 'ত্রুটি', '${error.message ?? error}');
    } catch (error) {
      _showError(colorScheme, 'ত্রুটি', 'এন্ট্রি সংরক্ষণ করা যায়নি: $error');
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
        if (shouldResetFields) {
          _amountController.clear();
          _noteController.clear();
          _selectedType = EntryType.credit;
          if (ensuredCustomer != null) {
            _selectedCustomer = ensuredCustomer;
            _customerInput = ensuredCustomer.name;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'দ্রুত এন্ট্রি যোগ করুন',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final customers = widget.customerController.customers
                  .where((customer) => customer.id != null)
                  .toList();
              final selectedId =
                  widget.entryController.selectedCustomerId.value;

              if (selectedId != null &&
                  (_selectedCustomer == null ||
                      _selectedCustomer!.id != selectedId)) {
                final match = _findCustomerById(customers, selectedId);
                if (match != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _updateCustomerText(match.name, customer: match);
                  });
                }
              }

              return Autocomplete<Customer>(
                displayStringForOption: (customer) => customer.name,
                initialValue: TextEditingValue(text: _customerInput),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  final query = textEditingValue.text.trim().toLowerCase();
                  if (query.isEmpty) {
                    return customers;
                  }
                  return customers.where(
                    (customer) =>
                        customer.name.toLowerCase().contains(query),
                  );
                },
                onSelected: (customer) {
                  if (customer.id != null) {
                    widget.entryController.selectedCustomerId.value =
                        customer.id;
                  }
                  _updateCustomerText(customer.name, customer: customer);
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  _customerTextController = textEditingController;
                  if (!_isProgrammaticCustomerUpdate &&
                      textEditingController.text != _customerInput) {
                    textEditingController.value = TextEditingValue(
                      text: _customerInput,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: _customerInput.length),
                      ),
                    );
                  }
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'কাস্টমার নির্বাচন করুন *',
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: textEditingController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              tooltip: 'কাস্টমার মুছুন',
                              onPressed: () {
                                textEditingController.clear();
                                widget.entryController.selectedCustomerId
                                    .value = null;
                                setState(() {
                                  _selectedCustomer = null;
                                  _customerInput = '';
                                });
                              },
                            ),
                    ),
                    onChanged: (value) {
                      if (_isProgrammaticCustomerUpdate) {
                        return;
                      }
                      setState(() {
                        _customerInput = value;
                        _selectedCustomer = null;
                      });
                      if (value.isEmpty) {
                        widget.entryController.selectedCustomerId.value = null;
                      }
                    },
                    textInputAction: TextInputAction.search,
                  );
                },
              );
            }),
            const SizedBox(height: 4),
            Text(
              'নতুন কাস্টমার তৈরি করতে নাম লিখে এন্ট্রি সংরক্ষণ করুন।',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              isSelected: [
                _selectedType == EntryType.credit,
                _selectedType == EntryType.debit,
              ],
              onPressed: (index) {
                setState(() {
                  _selectedType =
                      index == 0 ? EntryType.credit : EntryType.debit;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('টাকা পাবো'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('টাকা দেবো'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'টাকার পরিমাণ *',
                prefixText: '৳ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'ছোট নোট (ঐচ্ছিক)',
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _submit,
                    icon: _isSaving
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: Text(_isSaving
                        ? 'সংরক্ষণ হচ্ছে...'
                        : 'এন্ট্রি সংরক্ষণ করুন'),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: widget.onOpenFullForm,
                  icon: const Icon(Icons.list_alt),
                  label: const Text('বিস্তারিত ফর্ম'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showAddEntryDialog(
  BuildContext context,
  EntryController controller,
  CustomerController customerController,
) {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagsController = TextEditingController();
  final selectedType = Rx<EntryType>(EntryType.credit);
  final selectedDate = Rx<DateTime>(DateTime.now());
  final selectedCustomerId = Rx<int?>(controller.selectedCustomerId.value);
  final selectedCustomer = Rx<Customer?>(null);
  final RxString customerNameInput = ''.obs;
  TextEditingController? customerFieldController;

  Customer? findCustomerById(int id) {
    for (final customer in customerController.customers) {
      if (customer.id == id) {
        return customer;
      }
    }
    return null;
  }

  final initialCustomerId = controller.selectedCustomerId.value;
  if (initialCustomerId != null) {
    final existing = findCustomerById(initialCustomerId);
    if (existing != null) {
      selectedCustomer.value = existing;
      customerNameInput.value = existing.name;
      selectedCustomerId.value = existing.id;
    }
  }

  Get.dialog(
    AlertDialog(
      title: const Text('এন্ট্রি যোগ করুন'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () {
                final customers = customerController.customers
                    .where((customer) => customer.id != null)
                    .toList();

                final currentSelectedId = selectedCustomerId.value;
                if (currentSelectedId != null &&
                    (selectedCustomer.value == null ||
                        selectedCustomer.value!.id != currentSelectedId)) {
                  final match = findCustomerById(currentSelectedId);
                  if (match != null) {
                    selectedCustomer.value = match;
                    customerNameInput.value = match.name;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (customerFieldController != null &&
                          customerFieldController!.text != match.name) {
                        customerFieldController!.value = TextEditingValue(
                          text: match.name,
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: match.name.length),
                          ),
                        );
                      }
                    });
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Autocomplete<Customer>(
                      displayStringForOption: (customer) => customer.name,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final query =
                            textEditingValue.text.trim().toLowerCase();
                        if (query.isEmpty) {
                          return customers;
                        }
                        return customers.where(
                          (customer) =>
                              customer.name.toLowerCase().contains(query),
                        );
                      },
                      onSelected: (customer) {
                        selectedCustomer.value = customer;
                        selectedCustomerId.value = customer.id;
                        customerNameInput.value = customer.name;
                      },
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        customerFieldController = textEditingController;
                        if (textEditingController.text !=
                            customerNameInput.value) {
                          textEditingController.value = TextEditingValue(
                            text: customerNameInput.value,
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                  offset: customerNameInput.value.length),
                            ),
                          );
                        }
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: 'কাস্টমার *',
                            prefixIcon: const Icon(Icons.person),
                            suffixIcon: textEditingController.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      textEditingController.clear();
                                      customerNameInput.value = '';
                                      selectedCustomer.value = null;
                                      selectedCustomerId.value = null;
                                    },
                                  ),
                          ),
                          onChanged: (value) {
                            customerNameInput.value = value;
                            selectedCustomer.value = null;
                            if (value.isEmpty) {
                              selectedCustomerId.value = null;
                            }
                          },
                          textInputAction: TextInputAction.search,
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'নতুন কাস্টমার তৈরি করতে নাম লিখে এন্ট্রি সংরক্ষণ করুন।',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Obx(
              () => SegmentedButton<EntryType>(
                segments: const [
                  ButtonSegment(
                    value: EntryType.credit,
                    label: Text('টাকা পাবো'),
                    icon: Icon(Icons.add),
                  ),
                  ButtonSegment(
                    value: EntryType.debit,
                    label: Text('টাকা দেবো'),
                    icon: Icon(Icons.remove),
                  ),
                ],
                selected: {selectedType.value},
                onSelectionChanged: (Set<EntryType> newSelection) {
                  selectedType.value = newSelection.first;
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'পরিমাণ *',
                hintText: 'টাকার পরিমাণ লিখুন',
                prefixText: '৳ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'বিবরণ',
                hintText: 'বিবরণ লিখুন',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tagsController,
              decoration: const InputDecoration(
                labelText: 'ট্যাগ',
                hintText: 'কমা দিয়ে ট্যাগ লিখুন',
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => ListTile(
                title: const Text('তারিখ'),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy').format(selectedDate.value),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    selectedDate.value = date;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('বাতিল')),
        ElevatedButton(
          onPressed: () async {
            final amountText = amountController.text.trim();
            final amount = double.tryParse(amountText);
            final name = customerNameInput.value.trim();
            final colorScheme = Theme.of(context).colorScheme;

            if ((selectedCustomerId.value == null ||
                    selectedCustomerId.value! <= 0) &&
                name.isEmpty) {
              Get.snackbar(
                'কাস্টমার নেই',
                'প্রথমে কাস্টমার নির্বাচন করুন',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: colorScheme.error,
                colorText: colorScheme.onError,
              );
              return;
            }

            if (amount == null || amount <= 0) {
              Get.snackbar(
                'ভুল পরিমাণ',
                'সঠিক টাকার পরিমাণ লিখুন',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: colorScheme.error,
                colorText: colorScheme.onError,
              );
              return;
            }

            var targetCustomerId = selectedCustomerId.value;
            Customer? ensuredCustomer = selectedCustomer.value;

            try {
              if (targetCustomerId == null || targetCustomerId <= 0) {
                ensuredCustomer = await customerController
                    .findCustomerByName(name);
                if (ensuredCustomer == null) {
                  ensuredCustomer = await customerController
                      .createCustomerSilently(name);
                }

                targetCustomerId = ensuredCustomer.id;
                if (targetCustomerId != null) {
                  selectedCustomerId.value = targetCustomerId;
                  selectedCustomer.value = ensuredCustomer;
                  customerNameInput.value = ensuredCustomer.name;
                  controller.selectedCustomerId.value = targetCustomerId;
                }
              }

              if (targetCustomerId == null) {
                throw ArgumentError('কাস্টমার নির্বাচন করা সম্ভব হয়নি');
              }

              final entry = Entry(
                customerId: targetCustomerId,
                type: selectedType.value,
                amount: amount,
                description: descriptionController.text.isEmpty
                    ? null
                    : descriptionController.text,
                date: selectedDate.value,
                tags: tagsController.text.isEmpty
                    ? []
                    : tagsController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList(),
              );

              await controller.createEntry(entry);
            } on ArgumentError catch (error) {
              Get.snackbar(
                'ত্রুটি',
                '${error.message ?? error}',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: colorScheme.error,
                colorText: colorScheme.onError,
              );
            } catch (error) {
              Get.snackbar(
                'ত্রুটি',
                'এন্ট্রি সংরক্ষণ করা যায়নি: $error',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: colorScheme.error,
                colorText: colorScheme.onError,
              );
            }
          },
          child: const Text('এন্ট্রি সংরক্ষণ করুন'),
        ),
      ],
    ),
  ).whenComplete(() {
    customerNameInput.close();
    selectedCustomer.close();
    selectedCustomerId.close();
  });
}

void _showEntryDetails(BuildContext context, Entry entry) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: entry.type == EntryType.credit
                    ? AppTheme.creditColor
                    : AppTheme.debitColor,
                child: Icon(
                  entry.type == EntryType.credit ? Icons.add : Icons.remove,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '৳${entry.amount.toStringAsFixed(2)}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: entry.type == EntryType.credit
                                    ? AppTheme.creditColor
                                    : AppTheme.debitColor,
                              ),
                    ),
                    Text(
                      entry.type == EntryType.credit
                          ? 'টাকা পাবো'
                          : 'টাকা দেবো',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          if (entry.description != null) ...[
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('বিবরণ'),
              subtitle: Text(entry.description!),
              contentPadding: EdgeInsets.zero,
            ),
          ],
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('তারিখ'),
            subtitle: Text(DateFormat('MMM dd, yyyy').format(entry.date)),
            contentPadding: EdgeInsets.zero,
          ),
          if (entry.tags.isNotEmpty) ...[
            ListTile(
              leading: const Icon(Icons.label),
              title: const Text('ট্যাগ'),
              subtitle: Wrap(
                spacing: 4,
                children: entry.tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('বন্ধ করুন'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _confirmDelete(
  BuildContext context,
  EntryController controller,
  Entry entry,
) {
  Get.dialog(
    AlertDialog(
      title: const Text('এন্ট্রি মুছে ফেলুন'),
      content: Text(
        '৳${entry.amount.toStringAsFixed(2)} পরিমাণের এই এন্ট্রি কি মুছে ফেলতে চান?',
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('বাতিল')),
        ElevatedButton(
          onPressed: () {
            Get.back();
            controller.deleteEntry(entry.id!);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('মুছে ফেলুন'),
        ),
      ],
    ),
  );
}

void _exportPDF(EntryController controller) {
  Get.snackbar(
    'PDF এক্সপোর্ট',
    'PDF এক্সপোর্ট ফিচার শীঘ্রই আসছে',
    snackPosition: SnackPosition.BOTTOM,
  );
}
