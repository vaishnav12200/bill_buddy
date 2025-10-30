import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String paidBy;
  final double amount;
  final String description;
  final DateTime timestamp;

  Expense({
    required this.id,
    required this.paidBy,
    required this.amount,
    required this.description,
    required this.timestamp,
  });

  // Convert Firestore document to Expense object
  factory Expense.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      paidBy: data['paidBy'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert Expense object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'paidBy': paidBy,
      'amount': amount,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}