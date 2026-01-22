import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Provider for the notification service
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Notification channel IDs
class NotificationChannels {
  static const String sessionReminders = 'session_reminders';
  static const String messages = 'messages';
  static const String swapUpdates = 'swap_updates';
}

/// Notification IDs - using hash of swap/chat ID to ensure uniqueness
class NotificationIds {
  static int sessionReminder24h(String swapId) => 'reminder_24h_$swapId'.hashCode;
  static int sessionReminder1h(String swapId) => 'reminder_1h_$swapId'.hashCode;
  static int sessionReminder15m(String swapId) => 'reminder_15m_$swapId'.hashCode;
  static int newMessage(String chatId) => 'message_$chatId'.hashCode;
}

/// Service for managing local notifications
class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_getLocalTimezone()));

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    await _createNotificationChannels();

    _isInitialized = true;
    debugPrint('NotificationService: Initialized successfully');
  }

  /// Get local timezone name
  String _getLocalTimezone() {
    try {
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final hours = offset.inHours;
      final minutes = (offset.inMinutes % 60).abs();

      // Try to find a matching timezone
      if (hours == 5 && minutes == 30) return 'Asia/Kolkata'; // IST
      if (hours == 0) return 'UTC';
      if (hours == -5) return 'America/New_York'; // EST
      if (hours == -8) return 'America/Los_Angeles'; // PST
      if (hours == 1) return 'Europe/London'; // GMT+1

      // Default to UTC if unknown
      return 'UTC';
    } catch (e) {
      return 'UTC';
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // Session reminders channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.sessionReminders,
        'Session Reminders',
        description: 'Reminders for upcoming skill swap sessions',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      ),
    );

    // Messages channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.messages,
        'Messages',
        description: 'New chat message notifications',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
    );

    // Swap updates channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannels.swapUpdates,
        'Swap Updates',
        description: 'Updates about your skill swaps',
        importance: Importance.defaultImportance,
      ),
    );

    debugPrint('NotificationService: Android channels created');
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('NotificationService: Tapped notification with payload: ${response.payload}');
    // TODO: Navigate to appropriate screen based on payload
    // Payload format: "type:id" e.g., "session:swap123" or "chat:chat456"
  }

  /// Request notification permissions (iOS)
  Future<bool> requestPermissions() async {
    if (Platform.isIOS) {
      final iosPlugin = _notifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return granted ?? false;
    }

    if (Platform.isAndroid) {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      final granted = await androidPlugin?.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  /// Schedule session reminders (24h, 1h, 15m before)
  Future<void> scheduleSessionReminders({
    required String swapId,
    required String partnerName,
    required String skillName,
    required DateTime sessionDateTime,
  }) async {
    if (!_isInitialized) await initialize();

    final now = DateTime.now();

    // Cancel any existing reminders for this swap
    await cancelSessionReminders(swapId);

    // 24 hours before
    final reminder24h = sessionDateTime.subtract(const Duration(hours: 24));
    if (reminder24h.isAfter(now)) {
      await _scheduleNotification(
        id: NotificationIds.sessionReminder24h(swapId),
        title: 'Session Tomorrow',
        body: 'Your $skillName session with $partnerName is tomorrow!',
        scheduledDate: reminder24h,
        channelId: NotificationChannels.sessionReminders,
        payload: 'session:$swapId',
      );
      debugPrint('NotificationService: Scheduled 24h reminder for $swapId at $reminder24h');
    }

    // 1 hour before
    final reminder1h = sessionDateTime.subtract(const Duration(hours: 1));
    if (reminder1h.isAfter(now)) {
      await _scheduleNotification(
        id: NotificationIds.sessionReminder1h(swapId),
        title: 'Session in 1 Hour',
        body: 'Your $skillName session with $partnerName starts in 1 hour!',
        scheduledDate: reminder1h,
        channelId: NotificationChannels.sessionReminders,
        payload: 'session:$swapId',
      );
      debugPrint('NotificationService: Scheduled 1h reminder for $swapId at $reminder1h');
    }

    // 15 minutes before
    final reminder15m = sessionDateTime.subtract(const Duration(minutes: 15));
    if (reminder15m.isAfter(now)) {
      await _scheduleNotification(
        id: NotificationIds.sessionReminder15m(swapId),
        title: 'Session Starting Soon',
        body: 'Your $skillName session with $partnerName starts in 15 minutes! Get ready.',
        scheduledDate: reminder15m,
        channelId: NotificationChannels.sessionReminders,
        payload: 'session:$swapId',
      );
      debugPrint('NotificationService: Scheduled 15m reminder for $swapId at $reminder15m');
    }
  }

  /// Cancel all session reminders for a swap
  Future<void> cancelSessionReminders(String swapId) async {
    await _notifications.cancel(NotificationIds.sessionReminder24h(swapId));
    await _notifications.cancel(NotificationIds.sessionReminder1h(swapId));
    await _notifications.cancel(NotificationIds.sessionReminder15m(swapId));
    debugPrint('NotificationService: Cancelled reminders for $swapId');
  }

  /// Show a new message notification
  Future<void> showNewMessageNotification({
    required String chatId,
    required String senderName,
    required String message,
    String? senderPhoto,
  }) async {
    if (!_isInitialized) await initialize();

    // Truncate long messages
    final truncatedMessage = message.length > 100
        ? '${message.substring(0, 100)}...'
        : message;

    await _showNotification(
      id: NotificationIds.newMessage(chatId),
      title: senderName,
      body: truncatedMessage,
      channelId: NotificationChannels.messages,
      payload: 'chat:$chatId',
    );
  }

  /// Show a swap update notification
  Future<void> showSwapUpdateNotification({
    required String swapId,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await initialize();

    await _showNotification(
      id: swapId.hashCode,
      title: title,
      body: body,
      channelId: NotificationChannels.swapUpdates,
      payload: 'swap:$swapId',
    );
  }

  /// Schedule a notification
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String channelId,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Show an immediate notification
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  String _getChannelName(String channelId) {
    switch (channelId) {
      case NotificationChannels.sessionReminders:
        return 'Session Reminders';
      case NotificationChannels.messages:
        return 'Messages';
      case NotificationChannels.swapUpdates:
        return 'Swap Updates';
      default:
        return 'Notifications';
    }
  }

  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case NotificationChannels.sessionReminders:
        return 'Reminders for upcoming skill swap sessions';
      case NotificationChannels.messages:
        return 'New chat message notifications';
      case NotificationChannels.swapUpdates:
        return 'Updates about your skill swaps';
      default:
        return 'App notifications';
    }
  }

  /// Get all pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notifications.pendingNotificationRequests();
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('NotificationService: Cancelled all notifications');
  }
}