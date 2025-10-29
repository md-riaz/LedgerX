import 'package:intl/intl.dart';
import 'package:ledgerx/domain/entities/customer.dart';
import 'package:ledgerx/domain/entities/entry.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  Future<void> generateInvoice({
    required Customer customer,
    required List<Entry> entries,
    String? notes,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM dd, yyyy');

    // Calculate totals
    double totalCredit = 0;
    double totalDebit = 0;
    for (var entry in entries) {
      if (entry.type == EntryType.credit) {
        totalCredit += entry.amount;
      } else {
        totalDebit += entry.amount;
      }
    }
    final balance = totalCredit - totalDebit;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'LedgerX Invoice',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  dateFormat.format(DateTime.now()),
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Customer Information',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Name: ${customer.name}'),
          if ((customer.phone?.isNotEmpty ?? false))
            pw.Text('Phone: ${customer.phone}'),
          if ((customer.address?.isNotEmpty ?? false))
            pw.Text('Address: ${customer.address}'),
          if ((customer.notes?.isNotEmpty ?? false))
            pw.Text('Notes: ${customer.notes}'),
          pw.SizedBox(height: 20),
          pw.Text(
            'Transaction Details',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Type', 'Description', 'Amount'],
            data: entries
                .map((entry) => [
                      dateFormat.format(entry.date),
                      entry.type.name.toUpperCase(),
                      entry.description ?? '-',
                      '\$${entry.amount.toStringAsFixed(2)}',
                    ])
                .toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            cellStyle: const pw.TextStyle(fontSize: 10),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Total Credits: \$${totalCredit.toStringAsFixed(2)}'),
                  pw.Text('Total Debits: \$${totalDebit.toStringAsFixed(2)}'),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Balance: \$${balance.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (notes != null) ...[
            pw.SizedBox(height: 20),
            pw.Text(
              'Notes',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(notes, style: const pw.TextStyle(fontSize: 10)),
          ],
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  Future<void> generateLedgerReport({
    required List<Customer> customers,
    required Map<int, List<Entry>> entriesByCustomer,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM dd, yyyy');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Ledger Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Generated on ${dateFormat.format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          ...customers.map((customer) {
            final entries = entriesByCustomer[customer.id] ?? [];
            final balance = entries.fold<double>(
              0,
              (sum, entry) =>
                  sum +
                  (entry.type == EntryType.credit
                      ? entry.amount
                      : -entry.amount),
            );

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        customer.name,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Balance: \$${balance.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),
                if (entries.isNotEmpty)
                  pw.TableHelper.fromTextArray(
                    headers: ['Date', 'Type', 'Amount', 'Description'],
                    data: entries
                        .map((entry) => [
                              dateFormat.format(entry.date),
                              entry.type.name.toUpperCase(),
                              '\$${entry.amount.toStringAsFixed(2)}',
                              entry.description ?? '-',
                            ])
                        .toList(),
                    cellStyle: const pw.TextStyle(fontSize: 9),
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  )
                else
                  pw.Text('No entries',
                      style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 20),
              ],
            );
          }),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
