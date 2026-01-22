// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  NotificationType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body =>
      throw _privateConstructorUsedError; // Optional reference IDs for navigation
  String? get swapId => throw _privateConstructorUsedError;
  String? get chatId => throw _privateConstructorUsedError;
  String? get fromUserId => throw _privateConstructorUsedError;
  String? get fromUserName => throw _privateConstructorUsedError;
  String? get fromUserPhoto => throw _privateConstructorUsedError; // Status
  bool get isRead => throw _privateConstructorUsedError; // Metadata
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) then) =
      _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      NotificationType type,
      String title,
      String body,
      String? swapId,
      String? chatId,
      String? fromUserId,
      String? fromUserName,
      String? fromUserPhoto,
      bool isRead,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime createdAt});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? swapId = freezed,
    Object? chatId = freezed,
    Object? fromUserId = freezed,
    Object? fromUserName = freezed,
    Object? fromUserPhoto = freezed,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      swapId: freezed == swapId
          ? _value.swapId
          : swapId // ignore: cast_nullable_to_non_nullable
              as String?,
      chatId: freezed == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserId: freezed == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserName: freezed == fromUserName
          ? _value.fromUserName
          : fromUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserPhoto: freezed == fromUserPhoto
          ? _value.fromUserPhoto
          : fromUserPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(_$NotificationModelImpl value,
          $Res Function(_$NotificationModelImpl) then) =
      __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      NotificationType type,
      String title,
      String body,
      String? swapId,
      String? chatId,
      String? fromUserId,
      String? fromUserName,
      String? fromUserPhoto,
      bool isRead,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime createdAt});
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(_$NotificationModelImpl _value,
      $Res Function(_$NotificationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? swapId = freezed,
    Object? chatId = freezed,
    Object? fromUserId = freezed,
    Object? fromUserName = freezed,
    Object? fromUserPhoto = freezed,
    Object? isRead = null,
    Object? createdAt = null,
  }) {
    return _then(_$NotificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NotificationType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      swapId: freezed == swapId
          ? _value.swapId
          : swapId // ignore: cast_nullable_to_non_nullable
              as String?,
      chatId: freezed == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserId: freezed == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserName: freezed == fromUserName
          ? _value.fromUserName
          : fromUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserPhoto: freezed == fromUserPhoto
          ? _value.fromUserPhoto
          : fromUserPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl implements _NotificationModel {
  const _$NotificationModelImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.title,
      required this.body,
      this.swapId,
      this.chatId,
      this.fromUserId,
      this.fromUserName,
      this.fromUserPhoto,
      this.isRead = false,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required this.createdAt});

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final NotificationType type;
  @override
  final String title;
  @override
  final String body;
// Optional reference IDs for navigation
  @override
  final String? swapId;
  @override
  final String? chatId;
  @override
  final String? fromUserId;
  @override
  final String? fromUserName;
  @override
  final String? fromUserPhoto;
// Status
  @override
  @JsonKey()
  final bool isRead;
// Metadata
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  final DateTime createdAt;

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, type: $type, title: $title, body: $body, swapId: $swapId, chatId: $chatId, fromUserId: $fromUserId, fromUserName: $fromUserName, fromUserPhoto: $fromUserPhoto, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.swapId, swapId) || other.swapId == swapId) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.fromUserName, fromUserName) ||
                other.fromUserName == fromUserName) &&
            (identical(other.fromUserPhoto, fromUserPhoto) ||
                other.fromUserPhoto == fromUserPhoto) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      title,
      body,
      swapId,
      chatId,
      fromUserId,
      fromUserName,
      fromUserPhoto,
      isRead,
      createdAt);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationModel implements NotificationModel {
  const factory _NotificationModel(
      {required final String id,
      required final String userId,
      required final NotificationType type,
      required final String title,
      required final String body,
      final String? swapId,
      final String? chatId,
      final String? fromUserId,
      final String? fromUserName,
      final String? fromUserPhoto,
      final bool isRead,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required final DateTime createdAt}) = _$NotificationModelImpl;

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  NotificationType get type;
  @override
  String get title;
  @override
  String get body; // Optional reference IDs for navigation
  @override
  String? get swapId;
  @override
  String? get chatId;
  @override
  String? get fromUserId;
  @override
  String? get fromUserName;
  @override
  String? get fromUserPhoto; // Status
  @override
  bool get isRead; // Metadata
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get createdAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
