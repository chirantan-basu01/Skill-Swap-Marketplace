import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Transaction type enum
enum TransactionType {
  @JsonValue('welcome_bonus')
  welcomeBonus,
  @JsonValue('swap_earned')
  swapEarned,
  @JsonValue('swap_spent')
  swapSpent,
}

/// Transaction model representing a credit transaction
@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String userId,
    required TransactionType type,
    required double amount,
    required double balanceAfter,

    // Related swap (optional)
    String? swapId,
    String? otherUserId,
    String? otherUserName,
    String? skillName,

    @TimestampConverterNonNull() required DateTime createdAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}