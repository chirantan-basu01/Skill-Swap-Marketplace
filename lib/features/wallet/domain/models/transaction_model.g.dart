// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      balanceAfter: (json['balanceAfter'] as num).toDouble(),
      swapId: json['swapId'] as String?,
      otherUserId: json['otherUserId'] as String?,
      otherUserName: json['otherUserName'] as String?,
      skillName: json['skillName'] as String?,
      createdAt: const TimestampConverterNonNull()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'balanceAfter': instance.balanceAfter,
      'swapId': instance.swapId,
      'otherUserId': instance.otherUserId,
      'otherUserName': instance.otherUserName,
      'skillName': instance.skillName,
      'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.welcomeBonus: 'welcome_bonus',
  TransactionType.swapEarned: 'swap_earned',
  TransactionType.swapSpent: 'swap_spent',
};
