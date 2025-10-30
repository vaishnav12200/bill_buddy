import 'package:flutter/material.dart';
import '../models/balance.dart';
import '../models/expense.dart';
import '../screens/calculation_details_screen.dart';

class BalanceCard extends StatelessWidget {
  final List<Balance> balances;
  final List<Expense> expenses;
  final List<String> members;

  const BalanceCard({
    Key? key, 
    required this.balances,
    required this.expenses,
    required this.members,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (balances.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9333EA).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.account_balance_wallet, size: 48, color: Colors.white70),
              SizedBox(height: 12),
              Text(
                'No expenses yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Add your first expense below',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9333EA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.analytics_outlined, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Balance Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _showCalculationDetails(context),
                icon: const Icon(Icons.info_outline, color: Colors.white),
                tooltip: 'View Calculation Details',
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...balances.map((balance) => _buildBalanceRow(balance)).toList(),
          const Divider(color: Colors.white30, height: 24),
          _buildSettlementSuggestion(balances),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(Balance balance) {
    Color amountColor = balance.balance >= 0 ? Colors.greenAccent : Colors.redAccent;
    String prefix = balance.balance >= 0 ? '+' : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                balance.person[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  balance.person,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Paid ₹${balance.paid.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$prefix₹${balance.balance.abs().toStringAsFixed(0)}',
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementSuggestion(List<Balance> balances) {
    // Find who owes and who should receive
    Balance? owes = balances.firstWhere(
      (b) => b.balance < 0,
      orElse: () => Balance(person: '', paid: 0, shouldPay: 0, balance: 0),
    );
    Balance? receives = balances.firstWhere(
      (b) => b.balance > 0,
      orElse: () => Balance(person: '', paid: 0, shouldPay: 0, balance: 0),
    );

    if (owes.person.isEmpty || receives.person.isEmpty) {
      return const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
          SizedBox(width: 8),
          Text(
            'All settled up! 🎉',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        const Icon(Icons.swap_horiz, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${owes.person} owes ${receives.person} ₹${owes.balance.abs().toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _showCalculationDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalculationDetailsScreen(
          expenses: expenses,
          members: members,
        ),
      ),
    );
  }
}