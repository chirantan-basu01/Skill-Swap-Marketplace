import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:skill_swap_marketplace/core/constants/color_constants.dart';
import 'package:skill_swap_marketplace/core/constants/dimensions.dart';

/// Circular session timer with animated border and progress bar
class SessionTimer extends StatefulWidget {
  /// Start time of the session (when both users started)
  final DateTime? startTime;

  /// Total session duration in minutes
  final int totalMinutes;

  /// Whether the timer is running
  final bool isRunning;

  /// Callback when timer updates (every second)
  final ValueChanged<Duration>? onTick;

  /// Callback when session time is complete
  final VoidCallback? onTimeComplete;

  /// Callback when 5 minutes remaining
  final VoidCallback? onFiveMinutesRemaining;

  const SessionTimer({
    super.key,
    this.startTime,
    required this.totalMinutes,
    this.isRunning = false,
    this.onTick,
    this.onTimeComplete,
    this.onFiveMinutesRemaining,
  });

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  late AnimationController _pulseController;
  bool _fiveMinuteWarningFired = false;
  bool _timeCompleteFired = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    if (widget.isRunning && widget.startTime != null) {
      _calculateElapsed();
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(SessionTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning && widget.startTime != null) {
        _calculateElapsed();
        _startTimer();
      } else {
        _stopTimer();
      }
    }

    if (widget.startTime != oldWidget.startTime && widget.startTime != null) {
      _calculateElapsed();
    }
  }

  void _calculateElapsed() {
    if (widget.startTime != null) {
      _elapsed = DateTime.now().difference(widget.startTime!);
      if (_elapsed.isNegative) {
        _elapsed = Duration.zero;
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _calculateElapsed();
        });

        widget.onTick?.call(_elapsed);

        // Check for 5 minute warning
        final totalDuration = Duration(minutes: widget.totalMinutes);
        final remaining = totalDuration - _elapsed;

        if (!_fiveMinuteWarningFired &&
            remaining.inMinutes <= 5 &&
            remaining.inMinutes > 0) {
          _fiveMinuteWarningFired = true;
          widget.onFiveMinutesRemaining?.call();
        }

        // Check for time complete
        if (!_timeCompleteFired && _elapsed >= totalDuration) {
          _timeCompleteFired = true;
          widget.onTimeComplete?.call();
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalDuration = Duration(minutes: widget.totalMinutes);
    final progress = totalDuration.inSeconds > 0
        ? (_elapsed.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular timer
        _buildCircularTimer(progress),
        const SizedBox(height: Dimensions.lg),

        // Progress bar
        _buildProgressBar(progress),
        const SizedBox(height: Dimensions.sm),

        // Time labels
        _buildTimeLabels(totalDuration),
      ],
    );
  }

  Widget _buildCircularTimer(double progress) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = widget.isRunning
            ? 1.0 + (_pulseController.value * 0.02)
            : 1.0;

        return Transform.scale(
          scale: pulseValue,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.gray50,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated border
                CustomPaint(
                  size: const Size(160, 160),
                  painter: _TimerBorderPainter(
                    progress: progress,
                    color: AppColors.primaryBlue,
                    isAnimating: widget.isRunning,
                    animationValue: _pulseController.value,
                  ),
                ),

                // Time display
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatDuration(_elapsed),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'elapsed',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.xl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          backgroundColor: AppColors.gray200,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 1.0 ? AppColors.success : AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeLabels(Duration totalDuration) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatDuration(_elapsed),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            _formatDuration(totalDuration),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Custom painter for animated timer border
class _TimerBorderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isAnimating;
  final double animationValue;

  _TimerBorderPainter({
    required this.progress,
    required this.color,
    required this.isAnimating,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.gray200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );

    // Animated dash effect when running
    if (isAnimating && progress < 1.0) {
      final dashPaint = Paint()
        ..color = color.withValues(alpha: 0.3 + (animationValue * 0.3))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final dashRadius = radius + 8;
      final dashAngle = -math.pi / 2 + sweepAngle;
      final dashX = center.dx + dashRadius * math.cos(dashAngle);
      final dashY = center.dy + dashRadius * math.sin(dashAngle);

      canvas.drawCircle(Offset(dashX, dashY), 4, dashPaint);
    }
  }

  @override
  bool shouldRepaint(_TimerBorderPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        animationValue != oldDelegate.animationValue ||
        isAnimating != oldDelegate.isAnimating;
  }
}

/// Grace period countdown timer (for waiting state)
class GracePeriodTimer extends StatefulWidget {
  /// Total grace period in minutes
  final int totalMinutes;

  /// When the grace period started
  final DateTime startTime;

  /// Callback when grace period expires
  final VoidCallback? onExpired;

  const GracePeriodTimer({
    super.key,
    this.totalMinutes = 15,
    required this.startTime,
    this.onExpired,
  });

  @override
  State<GracePeriodTimer> createState() => _GracePeriodTimerState();
}

class _GracePeriodTimerState extends State<GracePeriodTimer> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _expiredFired = false;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    _startTimer();
  }

  void _calculateRemaining() {
    final totalDuration = Duration(minutes: widget.totalMinutes);
    final elapsed = DateTime.now().difference(widget.startTime);
    _remaining = totalDuration - elapsed;

    if (_remaining.isNegative) {
      _remaining = Duration.zero;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _calculateRemaining();
        });

        if (!_expiredFired && _remaining <= Duration.zero) {
          _expiredFired = true;
          widget.onExpired?.call();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.totalMinutes > 0
        ? 1.0 -
            (_remaining.inSeconds / (widget.totalMinutes * 60)).clamp(0.0, 1.0)
        : 1.0;

    final minutes = _remaining.inMinutes;
    final seconds = _remaining.inSeconds.remainder(60);
    final timeText = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Column(
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppColors.gray200,
            valueColor: AlwaysStoppedAnimation<Color>(
              _remaining.inMinutes <= 2 ? AppColors.warning : AppColors.gray400,
            ),
          ),
        ),
        const SizedBox(height: Dimensions.sm),

        // Time remaining
        Text(
          'Grace period: $timeText',
          style: TextStyle(
            fontSize: 13,
            color: _remaining.inMinutes <= 2
                ? AppColors.warning
                : AppColors.gray500,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

/// Waiting dots animation
class WaitingDots extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const WaitingDots({
    super.key,
    this.text = 'Waiting',
    this.style,
  });

  @override
  State<WaitingDots> createState() => _WaitingDotsState();
}

class _WaitingDotsState extends State<WaitingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _dotCount = (_dotCount + 1) % 4;
          });
          _controller.reset();
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * _dotCount;
    final style = widget.style ??
        const TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
        );

    return Text(
      '${widget.text}$dots',
      style: style,
    );
  }
}