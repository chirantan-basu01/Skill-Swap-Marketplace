import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/empty_state.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/error_widget.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/shimmer_loading.dart';
import 'package:skill_swap_marketplace/features/main/presentation/screens/main_shell_screen.dart';
import 'package:skill_swap_marketplace/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:skill_swap_marketplace/features/wallet/presentation/widgets/transaction_list.dart';

/// Wallet screen showing credit balance and transaction history
class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletStatsAsync = ref.watch(walletStatsProvider);
    final transactionsAsync = ref.watch(userTransactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(walletStatsProvider);
          ref.invalidate(userTransactionsProvider);
        },
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: AppColors.primaryBlue,
              expandedHeight: 0,
              pinned: true,
              title: const Text(
                'My Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  walletStatsAsync.when(
                    data: (stats) => BalanceCard(
                      balance: stats.balance,
                      totalEarned: stats.totalEarned,
                      totalSpent: stats.totalSpent,
                    ),
                    loading: () => _buildLoadingBalanceCard(),
                    error: (_, __) => _buildErrorBalanceCard(),
                  ),

                  // Low balance prompt
                  walletStatsAsync.whenData((stats) {
                    if (stats.balance < 1.0) {
                      return LowBalancePrompt(
                        onStartTeaching: () {
                          // Switch to Profile tab (index 4) in the bottom navigation
                          ref.read(navigationIndexProvider.notifier).state = 4;
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  }).valueOrNull ?? const SizedBox.shrink(),

                  const SizedBox(height: Dimensions.lg),

                  // Transaction History Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.lg,
                    ),
                    child: Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: Dimensions.sm),

                  // Transactions
                  transactionsAsync.when(
                    data: (transactions) {
                      if (transactions.isEmpty) {
                        return _buildEmptyTransactions(ref);
                      }

                      // Group transactions by date
                      final groups = _groupTransactions(transactions);

                      return TransactionList(groups: groups);
                    },
                    loading: () => _buildLoadingTransactions(),
                    error: (error, _) => _buildErrorTransactions(error.toString()),
                  ),

                  // Bottom padding for nav bar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TransactionGroup> _groupTransactions(
      List<dynamic> transactions) {
    if (transactions.isEmpty) return [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<dynamic>>{};
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
        transactions: entry.value.cast(),
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

  Widget _buildLoadingBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(Dimensions.lg),
      padding: const EdgeInsets.all(Dimensions.lg),
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      ),
    );
  }

  Widget _buildErrorBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(Dimensions.lg),
      padding: const EdgeInsets.all(Dimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.gray400,
          ),
          const SizedBox(height: Dimensions.sm),
          Text(
            'Failed to load balance',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions(WidgetRef ref) {
    return EmptyStateNoTransactions(
      onStartSwap: () {
        // Switch to Home tab (index 0) in the bottom navigation
        ref.read(navigationIndexProvider.notifier).state = 0;
      },
    );
  }

  Widget _buildLoadingTransactions() {
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.lg,
            vertical: Dimensions.xs,
          ),
          child: const ShimmerBox(height: 72, borderRadius: 8),
        ),
      ),
    );
  }

  Widget _buildErrorTransactions(String error) {
    return const Padding(
      padding: EdgeInsets.all(Dimensions.xl),
      child: InlineErrorWidget(
        message: 'Failed to load transactions',
      ),
    );
  }
}