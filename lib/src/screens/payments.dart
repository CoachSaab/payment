import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../modals/customer.dart';

class PaymentDetails extends StatefulWidget {
  final Customer customer;
  final Function(Customer, double) updateCustomer;

  const PaymentDetails({Key? key, required this.customer, required this.updateCustomer}) : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final TextEditingController _paymentController = TextEditingController();

  void _generateReceipt(double paymentAmount) async {
    final pdf = pw.Document();
    final receiptNumber = DateTime.now().millisecondsSinceEpoch.toString();
    final isFullyPaid = widget.customer.outstandingAmount <= 0;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('ANTLABS', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text('Coimbatore, Tamil Nadu'),
              pw.SizedBox(height: 20),
              pw.Text('Receipt Number: $receiptNumber'),
              pw.SizedBox(height: 20),
              pw.Text('Customer Name: ${widget.customer.name}'),
              pw.Text('Coimbatore, Tamil Nadu'),
              pw.SizedBox(height: 20),
              pw.Text('Payment Summary: We have received the amount, and the details are furnished below:'),
              pw.SizedBox(height: 10),
              pw.Text('Due Month:  ${widget.customer.dueMonth}, Amount:  ${widget.customer.dueAmount}'),
              pw.Text('Balance:  ${isFullyPaid ? 'Nil' : widget.customer.outstandingAmount.toStringAsFixed(2)}'),
              pw.SizedBox(height: 20),
              pw.Text('This is a system-generated receipt, and it doesn\'t require a signature.'),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details for ${widget.customer.name}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Due Amount: ₹${widget.customer.dueAmount.toStringAsFixed(2)}'),
            SizedBox(height: 5),
            Text('Due Date: ₹${widget.customer.dueDate}'),
            SizedBox(height: 10),
            TextField(
              controller: _paymentController,
              decoration: InputDecoration(
                labelText: 'Paying Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double? paymentAmount = double.tryParse(_paymentController.text);
                if (paymentAmount != null && paymentAmount >= 0) {
                  widget.updateCustomer(widget.customer, paymentAmount);
                  _generateReceipt(paymentAmount);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid amount')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[900]),
              child: Text('Submit Payment', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
