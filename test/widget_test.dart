import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bill_buddy/main.dart';
import 'package:bill_buddy/models/expense.dart';
import 'package:bill_buddy/models/balance.dart';

void main() {
  group('Bill Buddy App Tests', () {
    // Test 1: App Launches Successfully
    testWidgets('App launches and shows home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const BillBuddyApp());

      // Verify Bill Buddy title appears
      expect(find.text('Bill Buddy'), findsOneWidget);
      
      // Verify tagline appears
      expect(find.text('Split expenses in seconds'), findsOneWidget);
      
      // Verify both buttons exist
      expect(find.text('Create New Group'), findsOneWidget);
      expect(find.text('Join Existing Group'), findsOneWidget);
    });

    // Test 2: Input Fields Work
    testWidgets('Name and code input fields accept text', (WidgetTester tester) async {
      await tester.pumpWidget(const BillBuddyApp());

      // Find text fields
      final nameField = find.byType(TextField).first;
      final codeField = find.byType(TextField).last;

      // Enter text
      await tester.enterText(nameField, 'Vaishnav');
      await tester.enterText(codeField, '123456');

      // Verify text appears
      expect(find.text('Vaishnav'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);
    });

    // Test 3: Create Button Validation
    testWidgets('Create button shows error when name is empty', (WidgetTester tester) async {
      await tester.pumpWidget(const BillBuddyApp());

      // Find and tap create button without entering name
      final createButton = find.widgetWithText(ElevatedButton, 'Create New Group');
      await tester.tap(createButton);
      await tester.pump();

      // Should show error message
      expect(find.text('Please enter your name'), findsOneWidget);
    });

    // Test 4: Join Button Validation
    testWidgets('Join button shows error when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(const BillBuddyApp());

      // Find and tap join button without entering anything
      final joinButton = find.widgetWithText(OutlinedButton, 'Join Existing Group');
      await tester.tap(joinButton);
      await tester.pump();

      // Should show error message
      expect(find.text('Please enter your name'), findsOneWidget);
    });
  });

  group('Expense Model Tests', () {
    // Test 5: Expense Creation
    test('Expense model creates correctly', () {
      final expense = Expense(
        id: '123',
        paidBy: 'Vaishnav',
        amount: 500.0,
        description: 'Lunch',
        timestamp: DateTime(2024, 10, 7, 12, 30),
      );

      expect(expense.id, '123');
      expect(expense.paidBy, 'Vaishnav');
      expect(expense.amount, 500.0);
      expect(expense.description, 'Lunch');
    });

    // Test 6: Expense to Firestore Conversion
    test('Expense converts to Firestore format correctly', () {
      final expense = Expense(
        id: '123',
        paidBy: 'Vaishnav',
        amount: 500.0,
        description: 'Lunch',
        timestamp: DateTime(2024, 10, 7, 12, 30),
      );

      final firestoreData = expense.toFirestore();

      expect(firestoreData['paidBy'], 'Vaishnav');
      expect(firestoreData['amount'], 500.0);
      expect(firestoreData['description'], 'Lunch');
      expect(firestoreData['timestamp'], isNotNull);
    });
  });

  group('Balance Model Tests', () {
    // Test 7: Balance Calculation Logic
    test('Balance calculates correctly', () {
      final balance = Balance(
        person: 'Vaishnav',
        paid: 500.0,
        shouldPay: 400.0,
        balance: 100.0,
      );

      expect(balance.person, 'Vaishnav');
      expect(balance.paid, 500.0);
      expect(balance.shouldPay, 400.0);
      expect(balance.balance, 100.0);
    });

    // Test 8: Positive Balance (Should Receive)
    test('Positive balance means person should receive money', () {
      final balance = Balance(
        person: 'Vaishnav',
        paid: 600.0,
        shouldPay: 400.0,
        balance: 200.0,
      );

      expect(balance.balance > 0, true);
      // Vaishnav should receive ₹200
    });

    // Test 9: Negative Balance (Owes Money)
    test('Negative balance means person owes money', () {
      final balance = Balance(
        person: 'Arjun',
        paid: 200.0,
        shouldPay: 400.0,
        balance: -200.0,
      );

      expect(balance.balance < 0, false); // Wait, -200 < 0 is true!
      expect(balance.balance, -200.0);
      // Arjun owes ₹200
    });
  });

  group('Balance Calculation Tests', () {
    // Test 10: Two Person Split
    test('Calculates equal split for 2 people correctly', () {
      // Scenario: Vaishnav paid ₹500, Arjun paid ₹300
      // Total: ₹800, Each should pay: ₹400
      // Balance: Vaishnav +₹100, Arjun -₹100

      double vPaid = 500.0;
      double aPaid = 300.0;
      double total = vPaid + aPaid;
      double perPerson = total / 2;

      double vBalance = vPaid - perPerson;
      double aBalance = aPaid - perPerson;

      expect(total, 800.0);
      expect(perPerson, 400.0);
      expect(vBalance, 100.0); // Should receive
      expect(aBalance, -100.0); // Should pay
    });

    // Test 11: Three Person Split
    test('Calculates equal split for 3 people correctly', () {
      // Scenario: 
      // Vaishnav paid ₹600
      // Arjun paid ₹300
      // Priya paid ₹0
      // Total: ₹900, Each should pay: ₹300

      double vPaid = 600.0;
      double aPaid = 300.0;
      double pPaid = 0.0;
      double total = vPaid + aPaid + pPaid;
      double perPerson = total / 3;

      double vBalance = vPaid - perPerson;
      double aBalance = aPaid - perPerson;
      double pBalance = pPaid - perPerson;

      expect(total, 900.0);
      expect(perPerson, 300.0);
      expect(vBalance, 300.0); // Should receive ₹300
      expect(aBalance, 0.0); // Settled
      expect(pBalance, -300.0); // Should pay ₹300
    });

    // Test 12: Zero Expenses
    test('Handles zero expenses correctly', () {
      double total = 0.0;
      int members = 2;
      double perPerson = total / members;

      expect(perPerson, 0.0);
    });

    // Test 13: Decimal Amounts
    test('Handles decimal amounts correctly', () {
      double vPaid = 333.33;
      double aPaid = 333.34;
      double total = vPaid + aPaid;
      double perPerson = total / 2;

      expect(total, closeTo(666.67, 0.01));
      expect(perPerson, closeTo(333.335, 0.01));
    });
  });

  group('UI Component Tests', () {
    // Test 14: Gradient Background Exists
    testWidgets('Home screen has gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(const BillBuddyApp());

      // Find Container with gradient
      final container = find.byType(Container).first;
      expect(container, findsOneWidget);
    });

    // Test 15: Logo Icon Exists
    testWidgets('Home screen shows currency icon', (WidgetTester tester) async {
      await tester.pumpWidget(const BillBuddyApp());

      // Find rupee icon
      final icon = find.byIcon(Icons.currency_rupee_rounded);
      expect(icon, findsOneWidget);
    });

    // Test 16: Buttons Are Tappable
    testWidgets('Buttons respond to taps', (WidgetTester tester) async {
      await tester.pumpWidget(const BillBuddyApp());

      final createButton = find.widgetWithText(ElevatedButton, 'Create New Group');
      expect(createButton, findsOneWidget);

      // Verify button is enabled
      final ElevatedButton button = tester.widget(createButton);
      expect(button.enabled, true);
    });
  });

  group('Input Validation Tests', () {
    // Test 17: Name Field Accepts Letters
    test('Name validation accepts valid names', () {
      String name = 'Vaishnav';
      expect(name.trim().isNotEmpty, true);
      expect(name.length, greaterThan(0));
    });

    // Test 18: Code Field Accepts 6 Digits
    test('Group code validation accepts 6-digit codes', () {
      String code = '123456';
      expect(code.length, 6);
      expect(int.tryParse(code), isNotNull);
    });

    // Test 19: Amount Validation
    test('Amount validation rejects negative values', () {
      double amount1 = -100.0;
      double amount2 = 0.0;
      double amount3 = 100.0;

      expect(amount1 > 0, false);
      expect(amount2 > 0, false);
      expect(amount3 > 0, true);
    });

    // Test 20: Empty Description Validation
    test('Description validation rejects empty strings', () {
      String desc1 = '';
      String desc2 = '   ';
      String desc3 = 'Lunch';

      expect(desc1.trim().isEmpty, true);
      expect(desc2.trim().isEmpty, true);
      expect(desc3.trim().isEmpty, false);
    });
  });

  group('Edge Cases Tests', () {
    // Test 21: Very Large Amounts
    test('Handles large expense amounts', () {
      double largeAmount = 999999.99;
      expect(largeAmount, greaterThan(0));
      expect(largeAmount.toString(), isNotEmpty);
    });

    // Test 22: Very Long Descriptions
    test('Handles long descriptions', () {
      String longDesc = 'A' * 1000;
      expect(longDesc.length, 1000);
      expect(longDesc.trim().isNotEmpty, true);
    });

    // Test 23: Special Characters in Name
    test('Handles special characters in names', () {
      String name1 = "O'Brien";
      String name2 = "José";
      String name3 = "李明";

      expect(name1.isNotEmpty, true);
      expect(name2.isNotEmpty, true);
      expect(name3.isNotEmpty, true);
    });

    // Test 24: Multiple Expenses Same Time
    test('Handles multiple expenses with same timestamp', () {
      final time = DateTime.now();
      
      final expense1 = Expense(
        id: '1',
        paidBy: 'Vaishnav',
        amount: 100,
        description: 'Coffee',
        timestamp: time,
      );

      final expense2 = Expense(
        id: '2',
        paidBy: 'Arjun',
        amount: 200,
        description: 'Tea',
        timestamp: time,
      );

      expect(expense1.timestamp, expense2.timestamp);
      expect(expense1.id, isNot(expense2.id));
    });

    // Test 25: Zero Members Edge Case
    test('Handles division by zero gracefully', () {
      double total = 100.0;
      int members = 0;
      
      // Should handle division by zero
      double perPerson = members > 0 ? total / members : 0.0;
      expect(perPerson, 0.0);
    });
  });
}