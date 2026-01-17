import 'package:skill_swap_marketplace/core/utils/typedefs.dart';
import 'package:skill_swap_marketplace/features/swap/domain/models/swap_model.dart';

/// Abstract repository for swap operations
abstract class SwapRepository {
  /// Create a new swap request
  FutureEither<SwapModel> createSwap(SwapModel swap);

  /// Get swap by ID
  FutureEither<SwapModel> getSwapById(String swapId);

  /// Get all swaps for a user (as requester or provider)
  Stream<List<SwapModel>> getUserSwaps(String userId);

  /// Get swaps by status for a user
  Stream<List<SwapModel>> getUserSwapsByStatus(String userId, SwapStatus status);

  /// Get pending swaps where user is the provider (incoming requests)
  Stream<List<SwapModel>> getIncomingRequests(String userId);

  /// Get pending swaps where user is the requester (outgoing requests)
  Stream<List<SwapModel>> getOutgoingRequests(String userId);

  /// Get active swaps (accepted or scheduled)
  Stream<List<SwapModel>> getActiveSwaps(String userId);

  /// Get completed swaps
  Stream<List<SwapModel>> getCompletedSwaps(String userId);

  /// Update swap status
  FutureVoid updateSwapStatus(String swapId, SwapStatus status);

  /// Accept a swap request
  FutureVoid acceptSwap(String swapId);

  /// Decline a swap request
  FutureVoid declineSwap(String swapId);

  /// Cancel a swap (by requester or provider)
  FutureVoid cancelSwap(String swapId, String cancelledBy, String? reason);

  /// Schedule a session for an accepted swap
  FutureVoid scheduleSession({
    required String swapId,
    required DateTime scheduledDate,
    required String scheduledTime,
    String? videoLink,
  });

  /// Start a session (mark user as started)
  FutureVoid startSession(String swapId, String oderId);

  /// Complete a swap
  FutureVoid completeSwap(String swapId);

  /// Add rating to a swap
  FutureVoid addRating({
    required String swapId,
    required String oderId,
    required int stars,
    List<String> tags,
    String? review,
  });

  /// Check if user has an existing pending swap with another user
  FutureEither<bool> hasPendingSwapWith(String requesterId, String providerId);

  /// Get swap count for a user
  FutureEither<int> getSwapCount(String userId);
}