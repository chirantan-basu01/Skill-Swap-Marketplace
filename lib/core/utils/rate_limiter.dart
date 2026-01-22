import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Rate limit configuration for different actions
enum RateLimitAction {
  /// Swap requests - max 10 per hour
  swapRequest(maxAttempts: 10, windowMinutes: 60, cooldownMinutes: 5),

  /// Messages sent - max 50 per 5 minutes (spam prevention)
  sendMessage(maxAttempts: 50, windowMinutes: 5, cooldownMinutes: 1),

  /// Reports submitted - max 5 per day
  submitReport(maxAttempts: 5, windowMinutes: 1440, cooldownMinutes: 60),

  /// Password reset requests - max 3 per hour
  passwordReset(maxAttempts: 3, windowMinutes: 60, cooldownMinutes: 15),

  /// Profile updates - max 20 per hour
  profileUpdate(maxAttempts: 20, windowMinutes: 60, cooldownMinutes: 1),

  /// Search queries - max 100 per minute
  search(maxAttempts: 100, windowMinutes: 1, cooldownMinutes: 0),

  /// Session scheduling - max 5 per hour
  scheduleSession(maxAttempts: 5, windowMinutes: 60, cooldownMinutes: 5),

  /// Resend verification email - max 3 per 10 minutes
  resendVerification(maxAttempts: 3, windowMinutes: 10, cooldownMinutes: 2);

  final int maxAttempts;
  final int windowMinutes;
  final int cooldownMinutes;

  const RateLimitAction({
    required this.maxAttempts,
    required this.windowMinutes,
    required this.cooldownMinutes,
  });

  String get storageKey => 'rate_limit_$name';
}

/// Result of a rate limit check
class RateLimitResult {
  final bool isAllowed;
  final int remainingAttempts;
  final Duration? retryAfter;
  final String? message;

  const RateLimitResult({
    required this.isAllowed,
    required this.remainingAttempts,
    this.retryAfter,
    this.message,
  });

  factory RateLimitResult.allowed(int remaining) {
    return RateLimitResult(
      isAllowed: true,
      remainingAttempts: remaining,
    );
  }

  factory RateLimitResult.blocked(Duration retryAfter, String message) {
    return RateLimitResult(
      isAllowed: false,
      remainingAttempts: 0,
      retryAfter: retryAfter,
      message: message,
    );
  }
}

/// Rate limiter data stored in SharedPreferences
class _RateLimitData {
  final List<DateTime> attempts;

  _RateLimitData({required this.attempts});

  factory _RateLimitData.empty() => _RateLimitData(attempts: []);

  factory _RateLimitData.fromJson(List<String> data) {
    return _RateLimitData(
      attempts: data.map((s) => DateTime.parse(s)).toList(),
    );
  }

  List<String> toJson() {
    return attempts.map((d) => d.toIso8601String()).toList();
  }

  /// Remove attempts outside the time window
  _RateLimitData pruned(Duration window) {
    final cutoff = DateTime.now().subtract(window);
    return _RateLimitData(
      attempts: attempts.where((a) => a.isAfter(cutoff)).toList(),
    );
  }

  /// Add a new attempt
  _RateLimitData withNewAttempt() {
    return _RateLimitData(
      attempts: [...attempts, DateTime.now()],
    );
  }
}

/// Rate limiter utility for preventing abuse
class RateLimiter {
  final SharedPreferences _prefs;

  RateLimiter(this._prefs);

  /// Check if an action is allowed and record the attempt if so
  Future<RateLimitResult> checkAndRecord(RateLimitAction action) async {
    final result = check(action);

    if (result.isAllowed) {
      await _recordAttempt(action);
    }

    return result;
  }

  /// Check if an action is allowed (without recording)
  RateLimitResult check(RateLimitAction action) {
    final data = _getData(action);
    final window = Duration(minutes: action.windowMinutes);
    final prunedData = data.pruned(window);

    final attemptCount = prunedData.attempts.length;
    final remaining = action.maxAttempts - attemptCount;

    if (attemptCount >= action.maxAttempts) {
      // Rate limited - calculate retry time
      final oldestAttempt = prunedData.attempts.first;
      final windowEnd = oldestAttempt.add(window);
      final retryAfter = windowEnd.difference(DateTime.now());

      // If cooldown is set, use the longer of the two
      final cooldown = Duration(minutes: action.cooldownMinutes);
      final actualRetryAfter = retryAfter > cooldown ? retryAfter : cooldown;

      return RateLimitResult.blocked(
        actualRetryAfter,
        _getBlockedMessage(action, actualRetryAfter),
      );
    }

    return RateLimitResult.allowed(remaining - 1); // -1 because we're about to use one
  }

  /// Record an attempt for an action
  Future<void> _recordAttempt(RateLimitAction action) async {
    final data = _getData(action);
    final window = Duration(minutes: action.windowMinutes);
    final prunedData = data.pruned(window).withNewAttempt();

    await _prefs.setStringList(action.storageKey, prunedData.toJson());
  }

  /// Get rate limit data for an action
  _RateLimitData _getData(RateLimitAction action) {
    final stored = _prefs.getStringList(action.storageKey);
    if (stored == null || stored.isEmpty) {
      return _RateLimitData.empty();
    }
    return _RateLimitData.fromJson(stored);
  }

  /// Get remaining attempts for an action
  int getRemainingAttempts(RateLimitAction action) {
    final data = _getData(action);
    final window = Duration(minutes: action.windowMinutes);
    final prunedData = data.pruned(window);
    return action.maxAttempts - prunedData.attempts.length;
  }

  /// Clear rate limit data for an action (for testing)
  Future<void> clear(RateLimitAction action) async {
    await _prefs.remove(action.storageKey);
  }

  /// Clear all rate limit data
  Future<void> clearAll() async {
    for (final action in RateLimitAction.values) {
      await _prefs.remove(action.storageKey);
    }
  }

  String _getBlockedMessage(RateLimitAction action, Duration retryAfter) {
    final minutes = retryAfter.inMinutes;
    final seconds = retryAfter.inSeconds % 60;

    String timeStr;
    if (minutes > 0) {
      timeStr = '$minutes minute${minutes > 1 ? 's' : ''}';
      if (seconds > 0) {
        timeStr += ' and $seconds second${seconds > 1 ? 's' : ''}';
      }
    } else {
      timeStr = '$seconds second${seconds > 1 ? 's' : ''}';
    }

    switch (action) {
      case RateLimitAction.swapRequest:
        return 'Too many swap requests. Please try again in $timeStr.';
      case RateLimitAction.sendMessage:
        return 'Slow down! You\'re sending messages too quickly. Try again in $timeStr.';
      case RateLimitAction.submitReport:
        return 'You\'ve submitted too many reports today. Try again in $timeStr.';
      case RateLimitAction.passwordReset:
        return 'Too many password reset requests. Try again in $timeStr.';
      case RateLimitAction.profileUpdate:
        return 'Too many profile updates. Try again in $timeStr.';
      case RateLimitAction.search:
        return 'Too many searches. Try again in $timeStr.';
      case RateLimitAction.scheduleSession:
        return 'Too many session scheduling attempts. Try again in $timeStr.';
      case RateLimitAction.resendVerification:
        return 'Too many verification email requests. Try again in $timeStr.';
    }
  }
}

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

/// Provider for RateLimiter
final rateLimiterProvider = Provider<RateLimiter>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return RateLimiter(prefs);
});

/// Extension for easy rate limit checking in providers/notifiers
extension RateLimiterExtension on Ref {
  /// Check rate limit and show error if blocked
  Future<RateLimitResult> checkRateLimit(RateLimitAction action) {
    return read(rateLimiterProvider).checkAndRecord(action);
  }
}