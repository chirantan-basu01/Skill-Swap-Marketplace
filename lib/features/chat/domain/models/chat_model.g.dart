// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantInfoImpl _$$ParticipantInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$ParticipantInfoImpl(
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$$ParticipantInfoImplToJson(
        _$ParticipantInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'photoUrl': instance.photoUrl,
    };

_$LastMessageImpl _$$LastMessageImplFromJson(Map<String, dynamic> json) =>
    _$LastMessageImpl(
      text: json['text'] as String,
      senderId: json['senderId'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.text,
      createdAt: const TimestampConverterNonNull()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$LastMessageImplToJson(_$LastMessageImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'senderId': instance.senderId,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.system: 'system',
};

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participantInfo: (json['participantInfo'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ParticipantInfo.fromJson(e as Map<String, dynamic>)),
      ),
      swapId: json['swapId'] as String,
      lastMessage: json['lastMessage'] == null
          ? null
          : LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      createdAt: const TimestampConverterNonNull()
          .fromJson(json['createdAt'] as Timestamp),
      updatedAt: const TimestampConverterNonNull()
          .fromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants,
      'participantInfo':
          instance.participantInfo.map((k, e) => MapEntry(k, e.toJson())),
      'swapId': instance.swapId,
      'lastMessage': instance.lastMessage?.toJson(),
      'unreadCount': instance.unreadCount,
      'createdAt': const TimestampConverterNonNull().toJson(instance.createdAt),
      'updatedAt': const TimestampConverterNonNull().toJson(instance.updatedAt),
    };
