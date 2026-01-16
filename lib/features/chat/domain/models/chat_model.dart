import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_swap_marketplace/features/auth/domain/models/user_model.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

/// Message type enum
enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('system')
  system,
}

/// Participant info in a chat
@freezed
class ParticipantInfo with _$ParticipantInfo {
  const factory ParticipantInfo({
    required String name,
    String? photoUrl,
  }) = _ParticipantInfo;

  factory ParticipantInfo.fromJson(Map<String, dynamic> json) =>
      _$ParticipantInfoFromJson(json);
}

/// Last message preview in chat list
@freezed
class LastMessage with _$LastMessage {
  const factory LastMessage({
    required String text,
    required String senderId,
    @Default(MessageType.text) MessageType type,
    @TimestampConverterNonNull() required DateTime createdAt,
  }) = _LastMessage;

  factory LastMessage.fromJson(Map<String, dynamic> json) =>
      _$LastMessageFromJson(json);
}

/// Chat model representing a conversation between two users
@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    required List<String> participants,
    required Map<String, ParticipantInfo> participantInfo,
    required String swapId,
    LastMessage? lastMessage,
    @Default({}) Map<String, int> unreadCount,
    @TimestampConverterNonNull() required DateTime createdAt,
    @TimestampConverterNonNull() required DateTime updatedAt,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}
