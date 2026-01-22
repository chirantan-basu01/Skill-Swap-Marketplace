import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/report/domain/models/report_model.dart';

/// Abstract repository for report operations
abstract class ReportRepository {
  /// Submit a report against a user
  FutureEither<ReportModel> submitReport({
    required String reporterId,
    required String reporterName,
    required String reportedUserId,
    required String reportedUserName,
    required ReportReason reason,
    required String description,
    String? swapId,
    String? messageId,
  });

  /// Get reports submitted by a user
  FutureEither<List<ReportModel>> getReportsByReporter(String reporterId);

  /// Get reports against a user
  FutureEither<List<ReportModel>> getReportsAgainstUser(String userId);

  /// Check if user has already reported another user
  FutureEither<bool> hasReportedUser({
    required String reporterId,
    required String reportedUserId,
  });

  /// Block a user
  FutureVoid blockUser({
    required String userId,
    required String blockedUserId,
  });

  /// Unblock a user
  FutureVoid unblockUser({
    required String userId,
    required String blockedUserId,
  });

  /// Get list of blocked user IDs
  FutureEither<List<String>> getBlockedUsers(String userId);

  /// Check if a user is blocked
  FutureEither<bool> isUserBlocked({
    required String userId,
    required String otherUserId,
  });
}