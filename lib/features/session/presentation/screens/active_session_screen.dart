import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_swap_marketplace/core/config/app_router.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';
import 'package:skill_swap_marketplace/core/constants/route_constants.dart';
import 'package:skill_swap_marketplace/core/shared/widgets/user_avatar.dart';
import 'package:skill_swap_marketplace/features/main/presentation/screens/main_shell_screen.dart';
import 'package:skill_swap_marketplace/features/auth/presentation/providers/auth_provider.dart';
import 'package:skill_swap_marketplace/features/chat/presentation/providers/chat_provider.dart';
import 'package:skill_swap_marketplace/features/session/presentation/providers/session_provider.dart';
import 'package:skill_swap_marketplace/features/session/presentation/widgets/session_timer.dart';
import 'package:skill_swap_marketplace/features/session/presentation/widgets/video_link_button.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';

/// Active session screen for managing ongoing swap sessions
class ActiveSessionScreen extends ConsumerStatefulWidget {
  final String swapId;

  const ActiveSessionScreen({
    super.key,
    required this.swapId,
  });

  @override
  ConsumerState<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen> {
  @override
  Widget build(BuildContext context) {
    final authRepo = ref.watch(authRepositoryProvider);
    final currentUser = authRepo.currentUser;

    if (currentUser == null) {
      return _buildErrorScreen('Not authenticated');
    }

    final sessionState = ref.watch(
      activeSessionNotifierProvider(widget.swapId, currentUser.uid),
    );

    // Listen for state changes
    ref.listen(
      activeSessionNotifierProvider(widget.swapId, currentUser.uid),
      (previous, next) {
        if (next.status == ActiveSessionStatus.ended) {
          // Navigate to rating screen
          context.go(RouteNames.rating(widget.swapId));
        }
      },
    );

    return switch (sessionState.status) {
      ActiveSessionStatus.loading => _buildLoadingScreen(),
      ActiveSessionStatus.error => _buildErrorScreen(sessionState.errorMessage ?? 'An error occurred'),
      ActiveSessionStatus.waitingForPartner => _buildWaitingScreen(sessionState, currentUser.uid),
      ActiveSessionStatus.active => _buildActiveScreen(sessionState, currentUser.uid),
      ActiveSessionStatus.ended => _buildEndedScreen(),
      ActiveSessionStatus.cancelled => _buildCancelledScreen(sessionState),
    };
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.gray300,
            ),
            const SizedBox(height: Dimensions.md),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.lg),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingScreen(ActiveSessionState sessionState, String currentUserId) {
    final swap = sessionState.swap;
    if (swap == null) return _buildLoadingScreen();

    final partnerInfo = getPartnerInfo(swap, currentUserId);
    final session = swap.session;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Session'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.screenPaddingH),
          child: Column(
            children: [
              const Spacer(),

              // Partner avatar with pulse animation
              _PulsingAvatar(
                imageUrl: partnerInfo.photo,
                name: partnerInfo.name,
              ),
              const SizedBox(height: Dimensions.lg),

              // Waiting text
              if (sessionState.currentUserStarted) ...[
                Text(
                  'Waiting for ${partnerInfo.name}...',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: Dimensions.sm),
                Text(
                  "You're ready! Waiting for\n${partnerInfo.name} to start the session.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ] else ...[
                Text(
                  'Ready to Start?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: Dimensions.sm),
                Text(
                  'Start the session when both you and\n${partnerInfo.name} are ready.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],

              const SizedBox(height: Dimensions.lg),

              // Session info
              Container(
                padding: const EdgeInsets.all(Dimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(Dimensions.radiusMd),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.school, size: 18, color: AppColors.primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          'Learning ${partnerInfo.skillName}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatDurationDisplay(swap.duration),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Dimensions.lg),

              // Grace period timer (if user has started)
              if (sessionState.currentUserStarted && session != null)
                GracePeriodTimer(
                  startTime: DateTime.now().subtract(const Duration(seconds: 30)),
                  onExpired: () {
                    // Show no-show option
                  },
                ),

              const Spacer(),

              // Start session button (or status)
              StartSessionButton(
                hasStarted: sessionState.currentUserStarted,
                onPressed: () async {
                  final notifier = ref.read(
                    activeSessionNotifierProvider(widget.swapId, currentUserId).notifier,
                  );
                  await notifier.startSession();
                },
              ),
              const SizedBox(height: Dimensions.md),

              // Video call button
              VideoLinkButton(
                videoLink: session?.videoLink,
              ),
              const SizedBox(height: Dimensions.md),

              // Cancel option (only if not started)
              if (!sessionState.currentUserStarted)
                TextButton(
                  onPressed: () => _showCancelDialog(),
                  child: const Text(
                    'Cancel Session',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                    ),
                  ),
                )
              else if (!sessionState.partnerStarted)
                TextButton(
                  onPressed: () => _showNoShowDialog(sessionState, currentUserId),
                  child: const Text(
                    'Mark as No-Show',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                    ),
                  ),
                ),

              const SizedBox(height: Dimensions.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveScreen(ActiveSessionState sessionState, String currentUserId) {
    final swap = sessionState.swap;
    if (swap == null) return _buildLoadingScreen();

    final partnerInfo = getPartnerInfo(swap, currentUserId);
    final session = swap.session;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Animated header
              _ActiveSessionHeader(
                onEndSession: () => _showEndSessionDialog(sessionState, currentUserId),
                onBack: () => context.pop(),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.screenPaddingH),
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.lg),

                      // Partner avatar
                      UserAvatar(
                        imageUrl: partnerInfo.photo,
                        name: partnerInfo.name,
                        size: AvatarSize.lg,
                        showOnlineIndicator: true,
                        isOnline: true,
                        borderWidth: 4,
                        borderColor: Colors.white,
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Partner name
                      Text(
                        'Session with ${partnerInfo.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: Dimensions.xs),

                      // Skill being learned
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.school, size: 18, color: AppColors.gray500),
                          const SizedBox(width: 6),
                          Text(
                            'Learning ${partnerInfo.skillName}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: Dimensions.xl),

                      // Timer
                      SessionTimer(
                        startTime: sessionState.sessionStartTime,
                        totalMinutes: sessionState.sessionDurationMinutes,
                        isRunning: true,
                        onFiveMinutesRemaining: () {
                          final notifier = ref.read(
                            activeSessionNotifierProvider(widget.swapId, currentUserId).notifier,
                          );
                          notifier.showFiveMinuteWarning();
                        },
                        onTimeComplete: () {
                          final notifier = ref.read(
                            activeSessionNotifierProvider(widget.swapId, currentUserId).notifier,
                          );
                          notifier.showTimeUpModal();
                        },
                      ),

                      const SizedBox(height: Dimensions.xl),

                      // Video call button
                      VideoLinkButton(
                        videoLink: session?.videoLink,
                        onOpened: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      const SizedBox(height: Dimensions.md),

                      // Open chat button
                      OpenChatButton(
                        onPressed: () => _openChat(swap),
                      ),

                      const SizedBox(height: Dimensions.xl),

                      // Report issue
                      ReportIssueButton(
                        onPressed: () => _showReportDialog(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 5 minute warning banner
          if (sessionState.showFiveMinuteWarning)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: Dimensions.md,
              right: Dimensions.md,
              child: _WarningBanner(
                message: 'Session ends in 5 minutes',
                onDismiss: () {
                  final notifier = ref.read(
                    activeSessionNotifierProvider(widget.swapId, currentUserId).notifier,
                  );
                  notifier.dismissFiveMinuteWarning();
                },
              ),
            ),

          // Time up modal
          if (sessionState.showTimeUpModal)
            _TimeUpModal(
              duration: swap.duration,
              onEndSession: () async {
                final notifier = ref.read(
                  activeSessionNotifierProvider(widget.swapId, currentUserId).notifier,
                );
                await notifier.endSession();
              },
              onContinue: () {
                final notifier = ref.read(
                  activeSessionNotifierProvider(widget.swapId, currentUserId).notifier,
                );
                notifier.dismissTimeUpModal();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEndedScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: Dimensions.md),
            const Text(
              'Session Ended',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: Dimensions.sm),
            const Text(
              'Redirecting to rating...',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledScreen(ActiveSessionState sessionState) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Session'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cancel_outlined,
                size: 64,
                color: AppColors.gray400,
              ),
              const SizedBox(height: Dimensions.md),
              const Text(
                'Session Cancelled',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.sm),
              const Text(
                'This session has been cancelled.\nNo credits were exchanged.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: Dimensions.xl),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Set navigation to Home tab (index 0)
                    ref.read(navigationIndexProvider.notifier).state = 0;
                    // Navigate to main shell with bottom nav
                    const HomeRoute().go(context);
                  },
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEndSessionDialog(ActiveSessionState sessionState, String currentUserId) {
    final elapsed = sessionState.sessionStartTime != null
        ? DateTime.now().difference(sessionState.sessionStartTime!)
        : Duration.zero;

    final elapsedText = _formatDuration(elapsed);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End this session?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session duration: $elapsedText'),
            const SizedBox(height: 8),
            const Text(
              "You'll both be asked to rate the session afterward.",
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Going'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final notifier = ref.read(
                activeSessionNotifierProvider(widget.swapId, currentUserId).notifier,
              );
              await notifier.endSession();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel session?'),
        content: const Text(
          'Are you sure you want to cancel this session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No, keep it'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Session'),
          ),
        ],
      ),
    );
  }

  void _showNoShowDialog(ActiveSessionState sessionState, String currentUserId) {
    final partnerName = sessionState.swap != null
        ? getPartnerInfo(sessionState.swap!, currentUserId).name
        : 'your partner';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$partnerName hasn\'t joined'),
        content: Text(
          'They may have a connection issue. You can wait, or mark as no-show.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Wait a bit longer'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final notifier = ref.read(
                activeSessionNotifierProvider(widget.swapId, currentUserId).notifier,
              );
              await notifier.markAsNoShow();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Mark as No-Show'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    // TODO: Navigate to report screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report feature coming soon')),
    );
  }

  Future<void> _openChat(SwapModel swap) async {
    // Find or get chat for this swap
    final chatRepo = ref.read(chatRepositoryProvider);
    final result = await chatRepo.getChatBySwapId(swap.id);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message ?? 'Could not open chat')),
        );
      },
      (chat) {
        if (chat != null) {
          context.push(RouteNames.chatDetail(chat.id));
        }
      },
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}

/// Pulsing avatar for waiting state
class _PulsingAvatar extends StatefulWidget {
  final String? imageUrl;
  final String name;

  const _PulsingAvatar({
    required this.imageUrl,
    required this.name,
  });

  @override
  State<_PulsingAvatar> createState() => _PulsingAvatarState();
}

class _PulsingAvatarState extends State<_PulsingAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: UserAvatar(
            imageUrl: widget.imageUrl,
            name: widget.name,
            size: AvatarSize.lg,
            borderWidth: 4,
            borderColor: AppColors.primarySurface,
          ),
        );
      },
    );
  }
}

/// Active session header with gradient background
class _ActiveSessionHeader extends StatelessWidget {
  final VoidCallback onEndSession;
  final VoidCallback onBack;

  const _ActiveSessionHeader({
    required this.onEndSession,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 8,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue,
            Color(0xFF7C3AED), // Purple
          ],
        ),
      ),
      child: Row(
        children: [
          EndSessionButton(
            onPressed: onEndSession,
          ),
          const Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LiveIndicator(),
                  SizedBox(width: 8),
                  Text(
                    'Session in Progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Back button
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            tooltip: 'Minimize',
          ),
        ],
      ),
    );
  }
}

/// Live indicator dot with pulse animation
class _LiveIndicator extends StatefulWidget {
  const _LiveIndicator();

  @override
  State<_LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<_LiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success,
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.5 + (_controller.value * 0.3)),
                blurRadius: 4 + (_controller.value * 4),
                spreadRadius: _controller.value * 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Warning banner for 5 minute warning
class _WarningBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _WarningBanner({
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(Dimensions.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.md,
          vertical: Dimensions.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.warningSurface,
          borderRadius: BorderRadius.circular(Dimensions.radiusSm),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 18,
              color: AppColors.warning,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray800,
                ),
              ),
            ),
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              color: AppColors.gray500,
            ),
          ],
        ),
      ),
    );
  }
}

/// Time up modal
class _TimeUpModal extends StatelessWidget {
  final double duration;
  final VoidCallback onEndSession;
  final VoidCallback onContinue;

  const _TimeUpModal({
    required this.duration,
    required this.onEndSession,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(Dimensions.xl),
          padding: const EdgeInsets.all(Dimensions.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(Dimensions.radiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.access_time,
                size: 48,
                color: AppColors.warning,
              ),
              const SizedBox(height: Dimensions.md),
              const Text(
                "Time's Up!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.sm),
              Text(
                'Your ${formatDurationDisplay(duration)} session has ended.\nReady to wrap up?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: Dimensions.lg),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onEndSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'End & Rate Session',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.sm),
              TextButton(
                onPressed: onContinue,
                child: const Text(
                  'Continue a bit longer',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}