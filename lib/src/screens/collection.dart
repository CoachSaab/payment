import 'package:flutter/material.dart';

class CollectionHistory extends StatelessWidget {
  final List<Transaction> transactions;

  CollectionHistory({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection History', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[900],
      ),
      body: transactions.isEmpty
          ? Center(
        child: Text(
          'No transactions yet',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Receipt Number: ${transaction.receiptNumber}'),
              subtitle: Text(
                'Customer Name: ${transaction.customerName}\n'
                    'Payment Date: ${transaction.paymentDate}\n'
                    'Paid Amount: ₹${transaction.paidAmount.toStringAsFixed(2)}\n'
                    'Status: ${transaction.status}',
              ),
            ),
          );
        },
      ),
    );
  }
}

class Transaction {
  final String receiptNumber;
  final String customerName;
  final String paymentDate;
  final double paidAmount;
  final String status;

  Transaction({
    required this.receiptNumber,
    required this.customerName,
    required this.paymentDate,
    required this.paidAmount,
    required this.status,
  });
}
