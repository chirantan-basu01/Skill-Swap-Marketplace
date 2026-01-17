import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skill_swap_marketplace/core/constants/firestore_constants.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/wallet/domain/models/transaction_model.dart';

part 'wallet_provider.g.dart';

/// Wallet statistics
class WalletStats {
  final double balance;
  final double totalEarned;
  final double totalSpent;
  final int transactionCount;

  const WalletStats({
    this.balance = 0,
    this.totalEarned = 0,
    this.totalSpent = 0,
    this.transactionCount = 0,
  });
}

/// Provider for user's wallet stats
@riverpod
Stream<WalletStats> walletStats(WalletStatsRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final currentUser = authRepo.currentUser;

  if (currentUser == null) {
    return Stream.value(const WalletStats());
  }

  final firestore = FirebaseFirestore.instance;

  // Listen to user document for balance changes
  return firestore
      .collection(FirestoreCollections.users)
      .doc(currentUser.uid)
      .snapshots()
      .asyncMap((userDoc) async {
    if (!userDoc.exists) {
      return const WalletStats(balance: 1.0);
    }

    final userData = userDoc.data()!;
    final rawBalance = userData[UserFields.creditBalance];
    final balance = (rawBalance is num) ? rawBalance.toDouble() : 1.0;

    // Get all transactions to calculate totals (handle case where collection doesn't exist)
    double totalEarned = 0;
    double totalSpent = 0;
    int transactionCount = 0;

    try {
      // Use subcollection path: /transactions/{userId}/history
      final transactionsSnapshot = await firestore
          .collection(FirestoreCollections.transactions)
          .doc(currentUser.uid)
          .collection('history')
          .get();

      for (final doc in transactionsSnapshot.docs) {
        final data = doc.data();
        final type = data[TransactionFields.type] as String?;
        final rawAmount = data[TransactionFields.amount];
        final amount = (rawAmount is num) ? rawAmount.toDouble() : 0.0;

        if (type == 'swap_earned' || type == 'welcome_bonus') {
          totalEarned += amount;
        } else if (type == 'swap_spent') {
          totalSpent += amount;
        }
      }
      transactionCount = transactionsSnapshot.docs.length;
    } catch (e) {
      // Transactions collection may not exist yet, that's OK
    }

    return WalletStats(
      balance: balance,
      totalEarned: totalEarned,
      totalSpent: totalSpent,
      transactionCount: transactionCount,
    );
  });
}

/// Provider for user's credit balance
@riverpod
Stream<double> creditBalance(CreditBalanceRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final currentUser = authRepo.currentUser;

  if (currentUser == null) {
    return Stream.value(0);
  }

  return FirebaseFirestore.instance
      .collection(FirestoreCollections.users)
      .doc(currentUser.uid)
      .snapshots()
      .map((doc) {
    if (!doc.exists) return 1.0;
    final rawBalance = doc.data()?[UserFields.creditBalance];
    return (rawBalance is num) ? rawBalance.toDouble() : 1.0;
  });
}

/// Provider for user's transactions
@riverpod
Stream<List<TransactionModel>> userTransactions(UserTransactionsRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final currentUser = authRepo.currentUser;

  if (currentUser == null) {
    return Stream.value([]);
  }

  // Use subcollection path: /transactions/{userId}/history
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.transactions)
      .doc(currentUser.uid)
      .collection('history')
      .snapshots()
      .map((snapshot) {
    final transactions = snapshot.docs.map((doc) {
      return TransactionModel.fromJson(doc.data());
    }).toList();

    // Sort by createdAt descending client-side
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return transactions.take(50).toList();
  }).handleError((error) {
    // Return empty list if collection doesn't exist or other errors
    return <TransactionModel>[];
  });
}

/// Grouped transactions by date
class TransactionGroup {
  final String label;
  final DateTime date;
  final List<TransactionModel> transactions;

  const TransactionGroup({
    required this.label,
    required this.date,
    required this.transactions,
  });
}

/// Provider for grouped transactions
@riverpod
List<TransactionGroup> groupedTransactions(Ref ref) {
  final transactionsAsync = ref.watch(userTransactionsProvider);

  return transactionsAsync.when(
    data: (transactions) => _groupTransactions(transactions),
    loading: () => <TransactionGroup>[],
    error: (_, __) => <TransactionGroup>[],
  );
}

List<TransactionGroup> _groupTransactions(List<TransactionModel> transactions) {
  if (transactions.isEmpty) return [];

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final groups = <String, List<TransactionModel>>{};
  final groupDates = <String, DateTime>{};

  for (final transaction in transactions) {
    final transactionDate = DateTime(
      transaction.createdAt.year,
      transaction.createdAt.month,
      transaction.createdAt.day,
    );

    String label;
    if (transactionDate == today) {
      label = 'Today';
    } else if (transactionDate == yesterday) {
      label = 'Yesterday';
    } else {
      label = _formatDate(transaction.createdAt);
    }

    groups[label] ??= [];
    groups[label]!.add(transaction);
    groupDates[label] = transactionDate;
  }

  return groups.entries.map((entry) {
    return TransactionGroup(
      label: entry.key,
      date: groupDates[entry.key]!,
      transactions: entry.value,
    );
  }).toList();
}

String _formatDate(DateTime date) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return '${months[date.month - 1]} ${date.day}';
}