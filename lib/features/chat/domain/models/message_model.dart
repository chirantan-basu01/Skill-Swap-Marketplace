import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';
import 'package:skill_swap_marketplace/features/chat/domain/models/chat_model.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

/// Message model representing a single chat message
@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String senderId,
    required String senderName,
    @Default(MessageType.text) MessageType type,
    required String content,
    String? imageUrl,
    @Default([]) List<String> readBy,
    @TimestampConverterNonNull() required DateTime createdAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
