import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Check if group exists
  Future<bool> groupExists(String groupCode) async {
    try {
      DocumentSnapshot doc = await _db.collection('groups').doc(groupCode).get();
      return doc.exists;
    } catch (e) {
      print('Error checking group: $e');
      return false;
    }
  }

  // Create new group
  Future<void> createGroup(String groupCode, List<String> members) async {
    try {
      await _db.collection('groups').doc(groupCode).set({
        'members': members,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating group: $e');
      throw e;
    }
  }

  // Get group members
  Future<List<String>> getMembers(String groupCode) async {
    try {
      DocumentSnapshot doc = await _db.collection('groups').doc(groupCode).get();
      if (doc.exists) {
        List<dynamic> members = (doc.data() as Map<String, dynamic>)['members'];
        return members.cast<String>();
      }
      return [];
    } catch (e) {
      print('Error getting members: $e');
      return [];
    }
  }

  // Add member to existing group
  Future<void> addMember(String groupCode, String memberName) async {
    try {
      await _db.collection('groups').doc(groupCode).update({
        'members': FieldValue.arrayUnion([memberName]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding member: $e');
      throw e;
    }
  }

  // Add expense
  Future<void> addExpense(String groupCode, Expense expense) async {
    try {
      await _db
          .collection('groups')
          .doc(groupCode)
          .collection('expenses')
          .add(expense.toFirestore());
      
      // Update group timestamp
      await _db.collection('groups').doc(groupCode).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding expense: $e');
      throw e;
    }
  }

  // Get expenses stream (real-time)
  Stream<List<Expense>> getExpensesStream(String groupCode) {
    return _db
        .collection('groups')
        .doc(groupCode)
        .collection('expenses')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Expense.fromFirestore(doc))
            .toList());
  }

  // Delete expense
  Future<void> deleteExpense(String groupCode, String expenseId) async {
    try {
      await _db
          .collection('groups')
          .doc(groupCode)
          .collection('expenses')
          .doc(expenseId)
          .delete();
    } catch (e) {
      print('Error deleting expense: $e');
      throw e;
    }
  }
}