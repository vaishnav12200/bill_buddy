import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/expense.dart';
import '../models/balance.dart';
import '../services/firestore_service.dart';
import '../services/language_service.dart';
import '../services/settings_service.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_card.dart';
import 'add_expense_screen.dart';
import 'settings_screen.dart';

class GroupScreen extends StatefulWidget {
  final String groupCode;
  final String userName;

  const GroupScreen({
    Key? key,
    required this.groupCode,
    required this.userName,
  }) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late SettingsService _settingsService;
  List<String> _members = [];
  bool _codeCopied = false;

  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    List<String> members = await _firestoreService.getMembers(widget.groupCode);
    setState(() {
      _members = members;
    });
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.groupCode));
    setState(() => _codeCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _codeCopied = false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Group code copied!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<Balance> _calculateBalances(List<Expense> expenses) {
    if (expenses.isEmpty || _members.isEmpty) return [];

    Map<String, double> totalPaid = {};
    for (var member in _members) {
      totalPaid[member] = 0;
    }

    double grandTotal = 0;
    for (var expense in expenses) {
      totalPaid[expense.paidBy] = (totalPaid[expense.paidBy] ?? 0) + expense.amount;
      grandTotal += expense.amount;
    }

    double perPerson = grandTotal / _members.length;

    List<Balance> balances = [];
    for (var member in _members) {
      double paid = totalPaid[member] ?? 0;
      double balance = paid - perPerson;
      balances.add(Balance(
        person: member,
        paid: paid,
        shouldPay: perPerson,
        balance: balance,
      ));
    }

    return balances;
  }

  Future<void> _deleteExpense(String expenseId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firestoreService.deleteExpense(widget.groupCode, expenseId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settingsService,
      builder: (context, child) {
        return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LanguageService.t('app_name'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _members.isNotEmpty ? _members.join(', ') : 'Loading...',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF9333EA),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF9333EA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  widget.groupCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _copyCode,
                  child: Icon(
                    _codeCopied ? Icons.check : Icons.copy,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _firestoreService.getExpensesStream(widget.groupCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Expense> expenses = snapshot.data ?? [];
          List<Balance> balances = _calculateBalances(expenses);
          
          // Update total spending in settings
          _settingsService.updateTotalSpent(expenses, widget.userName);

          return Column(
            children: [
              // Balance Summary
              Padding(
                padding: const EdgeInsets.all(16),
                child: BalanceCard(
                  balances: balances,
                  expenses: expenses,
                  members: _members,
                ),
              ),

              // Expenses List
              Expanded(
                child: expenses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No expenses yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap + to add your first expense',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          return ExpenseCard(
                            expense: expenses[index],
                            onDelete: () => _deleteExpense(expenses[index].id),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(
                groupCode: widget.groupCode,
                members: _members,
                currentUser: widget.userName,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF9333EA),
        icon: const Icon(Icons.add),
        label: Text(LanguageService.t('add_expense')),
      ),
        );
      },
    );
  }
}