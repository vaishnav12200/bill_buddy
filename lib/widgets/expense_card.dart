import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onDelete;

  const ExpenseCard({
    Key? key,
    required this.expense,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.receipt_long,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          expense.description,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Paid by ${expense.paidBy}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('MMM dd, hh:mm a').format(expense.timestamp),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${expense.amount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF9333EA),
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                color: Colors.red[300],
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}