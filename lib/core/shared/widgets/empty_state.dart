import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Generic empty state widget for displaying when there's no data
class EmptyState extends StatelessWidget {
  /// Emoji or icon string to display
  final String icon;

  /// Main title text
  final String title;

  /// Optional description text
  final String? description;

  /// Optional action button text
  final String? actionLabel;

  /// Optional action button callback
  final VoidCallback? onAction;

  /// Optional secondary action
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  /// Size variant
  final EmptyStateSize size;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.size = EmptyStateSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(size);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(config.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon/Emoji
            SizedBox(
              height: config.iconSize + 8,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  icon,
                  style: TextStyle(fontSize: config.iconSize),
                ),
              ),
            ),
            SizedBox(height: config.spacing),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: config.titleSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // Description
            if (description != null) ...[
              SizedBox(height: config.spacing / 2),
              Text(
                description!,
                style: TextStyle(
                  fontSize: config.descriptionSize,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action button
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: config.spacing * 1.5),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: config.buttonPaddingH,
                    vertical: config.buttonPaddingV,
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],

            // Secondary action
            if (secondaryActionLabel != null && onSecondaryAction != null) ...[
              SizedBox(height: config.spacing / 2),
              TextButton(
                onPressed: onSecondaryAction,
                child: Text(secondaryActionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _EmptyStateConfig _getConfig(EmptyStateSize size) {
    switch (size) {
      case EmptyStateSize.small:
        return const _EmptyStateConfig(
          padding: Dimensions.md,
          iconSize: 40,
          titleSize: 15,
          descriptionSize: 13,
          spacing: 8,
          buttonPaddingH: 16,
          buttonPaddingV: 8,
        );
      case EmptyStateSize.medium:
        return const _EmptyStateConfig(
          padding: Dimensions.xl,
          iconSize: 56,
          titleSize: 18,
          descriptionSize: 14,
          spacing: 12,
          buttonPaddingH: 24,
          buttonPaddingV: 12,
        );
      case EmptyStateSize.large:
        return const _EmptyStateConfig(
          padding: Dimensions.xxl,
          iconSize: 72,
          titleSize: 20,
          descriptionSize: 15,
          spacing: 16,
          buttonPaddingH: 32,
          buttonPaddingV: 14,
        );
    }
  }
}

enum EmptyStateSize { small, medium, large }

class _EmptyStateConfig {
  final double padding;
  final double iconSize;
  final double titleSize;
  final double descriptionSize;
  final double spacing;
  final double buttonPaddingH;
  final double buttonPaddingV;

  const _EmptyStateConfig({
    required this.padding,
    required this.iconSize,
    required this.titleSize,
    required this.descriptionSize,
    required this.spacing,
    required this.buttonPaddingH,
    required this.buttonPaddingV,
  });
}

// Pre-built empty states for common scenarios

/// Empty state for no matches found
class EmptyStateNoMatches extends StatelessWidget {
  final VoidCallback? onUpdateSkills;

  const EmptyStateNoMatches({
    super.key,
    this.onUpdateSkills,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: '\ud83d\ude14', // 😔
      title: 'No perfect matches yet',
      description: 'Try adding more skills to find\nbetter swap partners',
      actionLabel: onUpdateSkills != null ? 'Update Your Skills' : null,
      onAction: onUpdateSkills,
    );
  }
}

/// Empty state for no search results
class EmptyStateNoResults extends StatelessWidget {
  final String? query;
  final VoidCallback? onClearSearch;

  const EmptyStateNoResults({
    super.key,
    this.query,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: '\ud83d\udd0d', // 🔍
      title: 'No results found',
      description: query != null
          ? 'No matches for "$query"\nTry a different search term'
          : 'Try adjusting your search or filters',
      actionLabel: onClearSearch != null ? 'Clear Search' : null,
      onAction: onClearSearch,
    );
  }
}

/// Empty state for no messages
class EmptyStateNoMessages extends StatelessWidget {
  final VoidCallback? onFindPartners;

  const EmptyStateNoMessages({
    super.key,
    this.onFindPartners,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: '\ud83d\udcac', // 💬
      title: 'No messages yet',
      description: 'Start a swap to chat with\nskill partners',
      actionLabel: onFindPartners != null ? 'Find Swap Partners' : null,
      onAction: onFindPartners,
    );
  }
}

/// Empty state for no swaps (pending tab)
class EmptyStateNoPendingSwaps extends StatelessWidget {
  final VoidCallback? onFindPartners;

  const EmptyStateNoPendingSwaps({
    super.key,
    this.onFindPartners,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: '\ud83d\udced', // 📭
      title: 'No pending requests',
      description: 'When you send or receive swap\nrequests, they\'ll appear here',
      actionLabel: onFindPartners != null ? 'Find Someone to Swap With' : null,
      onAction: onFindPartners,
    );
  }
}

/// Empty state for no active swaps
class EmptyStateNoActiveSwaps extends StatelessWidget {
  final VoidCallback? onBrowsePending;

  const EmptyStateNoActiveSwaps({
    super.key,
    this.onBrowsePending,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: '\ud83e\udd1d', // 🤝
      title: 'No active swaps',
      description: 'Accept a request or have one\naccepted to start swapping',
      actionLabel: onBrowsePending != null ? 'Browse Pending Requests' : null,
      onAction: onBrowsePending,
    );
  }
}

/// Empty state for no completed swaps
class EmptyStateNoCompletedSwaps extends StatelessWidget {
  final VoidCallback? onStartSwap;

  const EmptyStateNoCompletedSwaps({
    super.key,
    this.onStartSwap,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: '\ud83c\udfc6', // 🏆
      title: 'No completed swaps yet',
      description: 'Complete your first swap to\nstart building your reputation',
      actionLabel: onStartSwap != null ? 'Start Your First Swap' : null,
      onAction: onStartSwap,
    );
  }
}

/// Empty state for no transactions
class EmptyStateNoTransactions extends StatelessWidget {
  final VoidCallback? onStartSwap;

  const EmptyStateNoTransactions({
    super.key,
    this.onStartSwap,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: '\ud83d\udcb3', // 💳
      title: 'No transactions yet',
      description: 'Your credit history will\nappear here after swaps',
      actionLabel: onStartSwap != null ? 'Find a Swap Partner' : null,
      onAction: onStartSwap,
    );
  }
}

/// Empty state for no users in category
class EmptyStateCategoryEmpty extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onAddSkills;

  const EmptyStateCategoryEmpty({
    super.key,
    required this.categoryName,
    this.onAddSkills,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: '\u2728', // ✨
      title: 'No teachers in $categoryName yet',
      description: 'Be the first to offer your\nskills to the community!',
      actionLabel: onAddSkills != null ? 'Add $categoryName Skills' : null,
      onAction: onAddSkills,
    );
  }
}

/// Empty state for welcome/new user
class EmptyStateWelcome extends StatelessWidget {
  const EmptyStateWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: '\ud83c\udf1f', // 🌟
      title: 'Welcome to Skill Swap!',
      description: 'We\'re finding the best matches for you.\nCheck back soon!',
    );
  }
}

/// Empty state for no notifications
class EmptyStateNoNotifications extends StatelessWidget {
  const EmptyStateNoNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: '\ud83d\udd14', // 🔔
      title: 'No notifications',
      description: 'You\'re all caught up!\nNew notifications will appear here',
    );
  }
}

/// Inline empty state (smaller, for use within cards/sections)
class EmptyStateInline extends StatelessWidget {
  final String icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateInline({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
