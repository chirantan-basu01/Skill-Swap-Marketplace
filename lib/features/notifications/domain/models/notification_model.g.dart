// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      swapId: json['swapId'] as String?,
      chatId: json['chatId'] as String?,
      fromUserId: json['fromUserId'] as String?,
      fromUserName: json['fromUserName'] as String?,
      fromUserPhoto: json['fromUserPhoto'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt:
          timestampToDateTimeNonNull(readTimestampValue(json, 'createdAt')),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'swapId': instance.swapId,
      'chatId': instance.chatId,
      'fromUserId': instance.fromUserId,
      'fromUserName': instance.fromUserName,
      'fromUserPhoto': instance.fromUserPhoto,
      'isRead': instance.isRead,
      'createdAt': dateTimeToTimestampNonNull(instance.createdAt),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.swapRequest: 'swap_request',
  NotificationType.swapAccepted: 'swap_accepted',
  NotificationType.swapDeclined: 'swap_declined',
  NotificationType.swapCancelled: 'swap_cancelled',
  NotificationType.sessionScheduled: 'session_scheduled',
  NotificationType.sessionReminder: 'session_reminder',
  NotificationType.sessionStarted: 'session_started',
  NotificationType.sessionCompleted: 'session_completed',
  NotificationType.newMessage: 'new_message',
  NotificationType.newRating: 'new_rating',
  NotificationType.creditsReceived: 'credits_received',
  NotificationType.system: 'system',
};
