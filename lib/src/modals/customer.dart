class Customer {
  final String name;
  double outstandingAmount;
  String paymentStatus;
  String dueDate;
  int dueMonth;
  double dueAmount;

  Customer({
    required this.name,
    required this.outstandingAmount,
    required this.paymentStatus,
    required this.dueDate,
    required this.dueMonth,
    required this.dueAmount,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? 'Unknown',
      outstandingAmount: (json['amount'] ?? 0.0).toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      dueDate: json['dueDate'] ?? 'N/A',
      dueMonth: (json['dueMonth'] ?? 0).toInt(),
      dueAmount: (json['paidAmount'] ?? 0.0).toDouble(),
    );
  }


}

