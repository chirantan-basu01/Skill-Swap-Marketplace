import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/features/wallet/domain/models/transaction_model.dart';
import 'package:skill_swap_marketplace/features/wallet/presentation/providers/wallet_provider.dart';

/// Transaction list widget
class TransactionList extends StatelessWidget {
  final List<TransactionGroup> groups;
  final VoidCallback? onRefresh;

  const TransactionList({
    super.key,
    required this.groups,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateHeader(label: group.label),
            ...group.transactions.map((transaction) {
              return TransactionItem(transaction: transaction);
            }),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(Dimensions.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppColors.gray300,
          ),
          const SizedBox(height: Dimensions.md),
          const Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Dimensions.xs),
          const Text(
            'Complete a swap to see your transactions here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;

  const _DateHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimensions.lg,
        right: Dimensions.lg,
        top: Dimensions.md,
        bottom: Dimensions.sm,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

/// Single transaction item widget
class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEarned = transaction.type == TransactionType.swapEarned ||
        transaction.type == TransactionType.welcomeBonus;
    final isBonus = transaction.type == TransactionType.welcomeBonus;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.lg,
          vertical: Dimensions.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: BorderSide(color: AppColors.gray100),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(isEarned, isBonus),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(isEarned, isBonus),
                size: 20,
                color: _getIconColor(isEarned, isBonus),
              ),
            ),
            const SizedBox(width: Dimensions.md),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Amount
                      Text(
                        '${isEarned ? '+' : '-'}${transaction.amount.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isEarned
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: Dimensions.sm),
                      // Primary label
                      Expanded(
                        child: Text(
                          _getPrimaryLabel(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Secondary label and time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getSecondaryLabel(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(transaction.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPrimaryLabel() {
    switch (transaction.type) {
      case TransactionType.welcomeBonus:
        return 'Welcome Bonus';
      case TransactionType.swapEarned:
        return 'Taught ${transaction.skillName ?? 'a skill'}';
      case TransactionType.swapSpent:
        return 'Learned ${transaction.skillName ?? 'a skill'}';
    }
  }

  String _getSecondaryLabel() {
    switch (transaction.type) {
      case TransactionType.welcomeBonus:
        return 'Account created';
      case TransactionType.swapEarned:
        return 'to ${transaction.otherUserName ?? 'Unknown'}';
      case TransactionType.swapSpent:
        return 'from ${transaction.otherUserName ?? 'Unknown'}';
    }
  }

  IconData _getIcon(bool isEarned, bool isBonus) {
    if (isBonus) return Icons.card_giftcard;
    return isEarned ? Icons.arrow_outward : Icons.arrow_downward;
  }

  Color _getIconBackgroundColor(bool isEarned, bool isBonus) {
    if (isBonus) return AppColors.primaryBlue.withOpacity(0.1);
    if (isEarned) return AppColors.success.withOpacity(0.1);
    return AppColors.gray100;
  }

  Color _getIconColor(bool isEarned, bool isBonus) {
    if (isBonus) return AppColors.primaryBlue;
    if (isEarned) return AppColors.success;
    return AppColors.textTertiary;
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }
}

/// Balance card widget for wallet screen
class BalanceCard extends StatelessWidget {
  final double balance;
  final double totalEarned;
  final double totalSpent;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.totalEarned,
    required this.totalSpent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(Dimensions.lg),
      padding: const EdgeInsets.all(Dimensions.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue,
            Color(0xFF1E40AF), // Darker blue
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Wallet icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: Dimensions.md),

          // Balance
          Text(
            balance.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'credits',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: Dimensions.lg),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  value: '+${totalEarned.toStringAsFixed(1)}',
                  label: 'earned',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: Dimensions.md),
              Expanded(
                child: _StatBox(
                  value: '-${totalSpent.toStringAsFixed(1)}',
                  label: 'spent',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;

  const _StatBox({
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.md,
        vertical: Dimensions.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Low balance prompt card
class LowBalancePrompt extends StatelessWidget {
  final VoidCallback? onStartTeaching;

  const LowBalancePrompt({
    super.key,
    this.onStartTeaching,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.lg),
      padding: const EdgeInsets.all(Dimensions.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: AppColors.warning,
            size: 24,
          ),
          const SizedBox(width: Dimensions.sm),
          Expanded(
            child: Text(
              'Earn more credits by teaching your skills to others!',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray800,
              ),
            ),
          ),
          TextButton(
            onPressed: onStartTeaching,
            child: const Text(
              'Start',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}