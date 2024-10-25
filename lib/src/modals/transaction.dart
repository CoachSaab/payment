class Transaction {
  String receiptNumber;
  String customerName;
  String paymentDate;
  double paidAmount;
  String status;
  String dueMonth;
  String dueAmount;



  Transaction({
    required this.receiptNumber,
    required this.customerName,
    required this.paymentDate,
    required this.paidAmount,
    required this.status,
    required this.dueMonth,
    required this.dueAmount,
  });
}
