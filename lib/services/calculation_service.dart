import '../models/expense.dart';
import 'language_service.dart';

class CalculationExplanation {
  final double totalExpenses;
  final int numberOfPeople;
  final double perPersonShare;
  final List<ExpenseBreakdown> expenseBreakdowns;
  final List<BalanceExplanation> balanceExplanations;
  final List<Settlement> settlements;

  CalculationExplanation({
    required this.totalExpenses,
    required this.numberOfPeople,
    required this.perPersonShare,
    required this.expenseBreakdowns,
    required this.balanceExplanations,
    required this.settlements,
  });
}

class ExpenseBreakdown {
  final String description;
  final String paidBy;
  final double amount;
  final double perPersonShare;

  ExpenseBreakdown({
    required this.description,
    required this.paidBy,
    required this.amount,
    required this.perPersonShare,
  });
}

class BalanceExplanation {
  final String person;
  final double totalPaid;
  final double shouldPay;
  final double balance;
  final String explanation;

  BalanceExplanation({
    required this.person,
    required this.totalPaid,
    required this.shouldPay,
    required this.balance,
    required this.explanation,
  });
}

class Settlement {
  final String from;
  final String to;
  final double amount;
  final String explanation;

  Settlement({
    required this.from,
    required this.to,
    required this.amount,
    required this.explanation,
  });
}

class CalculationService {
  static CalculationExplanation calculateWithExplanation(
    List<Expense> expenses,
    List<String> members,
  ) {
    if (expenses.isEmpty || members.isEmpty) {
      return CalculationExplanation(
        totalExpenses: 0,
        numberOfPeople: members.length,
        perPersonShare: 0,
        expenseBreakdowns: [],
        balanceExplanations: [],
        settlements: [],
      );
    }

    // Calculate total expenses
    double totalExpenses = expenses.fold(0, (sum, expense) => sum + expense.amount);
    double perPersonShare = totalExpenses / members.length;

    // Create expense breakdowns
    List<ExpenseBreakdown> expenseBreakdowns = expenses.map((expense) {
      return ExpenseBreakdown(
        description: expense.description,
        paidBy: expense.paidBy,
        amount: expense.amount,
        perPersonShare: expense.amount / members.length,
      );
    }).toList();

    // Calculate individual balances with explanations
    Map<String, double> totalPaid = {};
    for (var member in members) {
      totalPaid[member] = 0;
    }

    for (var expense in expenses) {
      totalPaid[expense.paidBy] = (totalPaid[expense.paidBy] ?? 0) + expense.amount;
    }

    List<BalanceExplanation> balanceExplanations = [];
    Map<String, double> balances = {};

    for (var member in members) {
      double paid = totalPaid[member] ?? 0;
      double balance = paid - perPersonShare;
      balances[member] = balance;

      String explanation = _generateBalanceExplanation(
        member,
        paid,
        perPersonShare,
        balance,
      );

      balanceExplanations.add(BalanceExplanation(
        person: member,
        totalPaid: paid,
        shouldPay: perPersonShare,
        balance: balance,
        explanation: explanation,
      ));
    }

    // Calculate settlements
    List<Settlement> settlements = _calculateSettlements(balances);

    return CalculationExplanation(
      totalExpenses: totalExpenses,
      numberOfPeople: members.length,
      perPersonShare: perPersonShare,
      expenseBreakdowns: expenseBreakdowns,
      balanceExplanations: balanceExplanations,
      settlements: settlements,
    );
  }

  static String _generateBalanceExplanation(
    String person,
    double paid,
    double shouldPay,
    double balance,
  ) {
    if (balance > 0) {
      return "$person ${LanguageService.t('paid_by')} ₹${paid.toStringAsFixed(0)} ${LanguageService.t('but')} ${LanguageService.t('should_pay')} ₹${shouldPay.toStringAsFixed(0)}. ${LanguageService.t('extra_paid')}: ₹${balance.toStringAsFixed(0)}";
    } else if (balance < 0) {
      return "$person ${LanguageService.t('paid_by')} ₹${paid.toStringAsFixed(0)} ${LanguageService.t('but')} ${LanguageService.t('should_pay')} ₹${shouldPay.toStringAsFixed(0)}. ${LanguageService.t('owes')}: ₹${(-balance).toStringAsFixed(0)}";
    } else {
      return "$person ${LanguageService.t('paid_exactly')} ₹${paid.toStringAsFixed(0)} - ${LanguageService.t('settled')}";
    }
  }

  static List<Settlement> _calculateSettlements(Map<String, double> balances) {
    List<Settlement> settlements = [];
    
    // Separate creditors (who are owed money) and debtors (who owe money)
    List<MapEntry<String, double>> creditors = [];
    List<MapEntry<String, double>> debtors = [];

    balances.forEach((person, balance) {
      if (balance > 0.01) {
        creditors.add(MapEntry(person, balance));
      } else if (balance < -0.01) {
        debtors.add(MapEntry(person, -balance));
      }
    });

    // Sort by amount
    creditors.sort((a, b) => b.value.compareTo(a.value));
    debtors.sort((a, b) => b.value.compareTo(a.value));

    // Calculate settlements
    int i = 0, j = 0;
    while (i < creditors.length && j < debtors.length) {
      String creditor = creditors[i].key;
      String debtor = debtors[j].key;
      double creditAmount = creditors[i].value;
      double debtAmount = debtors[j].value;

      double settlementAmount = creditAmount < debtAmount ? creditAmount : debtAmount;

      settlements.add(Settlement(
        from: debtor,
        to: creditor,
        amount: settlementAmount,
        explanation: "$debtor ${LanguageService.t('should_pay')} ₹${settlementAmount.toStringAsFixed(0)} ${LanguageService.t('to')} $creditor",
      ));

      creditors[i] = MapEntry(creditor, creditAmount - settlementAmount);
      debtors[j] = MapEntry(debtor, debtAmount - settlementAmount);

      if (creditors[i].value < 0.01) i++;
      if (debtors[j].value < 0.01) j++;
    }

    return settlements;
  }
}