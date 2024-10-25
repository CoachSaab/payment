import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:pay/src/screens/payments.dart';
import '../modals/customer.dart';
import 'collection.dart';

class Outstanding extends StatefulWidget {
  const Outstanding({super.key});

  @override
  State<Outstanding> createState() => _OutstandingState();
}

class _OutstandingState extends State<Outstanding> {
  List<Customer> customers = []; // Initialize as an empty list
  final List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers(); // Fetch customers when the widget is initialized
  }

  Future<void> _fetchCustomers() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/customers'));

    if (response.statusCode == 200) {
      final List<dynamic> customerData = json.decode(response.body);

      // Print the fetched customer data to debug
      print("Fetched Customer Data:");
      customerData.forEach((customer) {
        print(customer); // Print entire customer JSON object
      });

      setState(() {
        customers = customerData.map((json) => Customer.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load customers');
    }
  }

  void _updateCustomer(Customer customer, double paymentAmount) {
    setState(() {
      customer.outstandingAmount -= paymentAmount;
      if (customer.outstandingAmount <= 0) {
        customer.outstandingAmount = 0;
        customer.paymentStatus = 'Paid';
      } else if (paymentAmount > 0) {
        customer.paymentStatus = 'Overdue';
      } else {
        customer.paymentStatus = 'Pending';
      }
      transactions.add(Transaction(
        receiptNumber: DateTime.now().millisecondsSinceEpoch.toString(),
        customerName: customer.name,
        paymentDate: DateTime.now().toShortDateString(),
        paidAmount: paymentAmount,
        status: customer.paymentStatus,
      ));
    });
  }

  void _navigateToPaymentDetails(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetails(customer: customer, updateCustomer: _updateCustomer),
      ),
    );
  }

  void _navigateToCollectionHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionHistory(transactions: transactions),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green; // Color for 'Paid'
      case 'Overdue':
        return Colors.red; // Color for 'Overdue'
      case 'Pending':
      default:
        return Colors.blue; // Color for 'Pending'
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outstanding Payments', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[900],
      ),
      body: customers.isEmpty // Check if customers list is empty
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(customer.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Outstanding Amount: ₹ ${customer.outstandingAmount.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Payment Status: ${customer.paymentStatus}',
                          style: TextStyle(color: _getStatusColor(customer.paymentStatus)), // Change color based on status
                        ),
                      ],
                    ),
                    onTap: () => _navigateToPaymentDetails(customer),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _navigateToCollectionHistory,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[900]),
            child: Text('View Collection History', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

extension on DateTime {
  String toShortDateString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}
