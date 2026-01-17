// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swap_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SwapSession _$SwapSessionFromJson(Map<String, dynamic> json) {
  return _SwapSession.fromJson(json);
}

/// @nodoc
mixin _$SwapSession {
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get scheduledDate => throw _privateConstructorUsedError;
  String get scheduledTime => throw _privateConstructorUsedError;
  String get videoLink => throw _privateConstructorUsedError;
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp)
  DateTime? get actualStartTime => throw _privateConstructorUsedError;
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp)
  DateTime? get actualEndTime => throw _privateConstructorUsedError;
  bool get requesterStarted => throw _privateConstructorUsedError;
  bool get providerStarted => throw _privateConstructorUsedError;

  /// Serializes this SwapSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwapSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapSessionCopyWith<SwapSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapSessionCopyWith<$Res> {
  factory $SwapSessionCopyWith(
          SwapSession value, $Res Function(SwapSession) then) =
      _$SwapSessionCopyWithImpl<$Res, SwapSession>;
  @useResult
  $Res call(
      {@JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime scheduledDate,
      String scheduledTime,
      String videoLink,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      DateTime? actualStartTime,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      DateTime? actualEndTime,
      bool requesterStarted,
      bool providerStarted});
}

/// @nodoc
class _$SwapSessionCopyWithImpl<$Res, $Val extends SwapSession>
    implements $SwapSessionCopyWith<$Res> {
  _$SwapSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwapSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduledDate = null,
    Object? scheduledTime = null,
    Object? videoLink = null,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? requesterStarted = null,
    Object? providerStarted = null,
  }) {
    return _then(_value.copyWith(
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as String,
      videoLink: null == videoLink
          ? _value.videoLink
          : videoLink // ignore: cast_nullable_to_non_nullable
              as String,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requesterStarted: null == requesterStarted
          ? _value.requesterStarted
          : requesterStarted // ignore: cast_nullable_to_non_nullable
              as bool,
      providerStarted: null == providerStarted
          ? _value.providerStarted
          : providerStarted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SwapSessionImplCopyWith<$Res>
    implements $SwapSessionCopyWith<$Res> {
  factory _$$SwapSessionImplCopyWith(
          _$SwapSessionImpl value, $Res Function(_$SwapSessionImpl) then) =
      __$$SwapSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime scheduledDate,
      String scheduledTime,
      String videoLink,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      DateTime? actualStartTime,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      DateTime? actualEndTime,
      bool requesterStarted,
      bool providerStarted});
}

/// @nodoc
class __$$SwapSessionImplCopyWithImpl<$Res>
    extends _$SwapSessionCopyWithImpl<$Res, _$SwapSessionImpl>
    implements _$$SwapSessionImplCopyWith<$Res> {
  __$$SwapSessionImplCopyWithImpl(
      _$SwapSessionImpl _value, $Res Function(_$SwapSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwapSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduledDate = null,
    Object? scheduledTime = null,
    Object? videoLink = null,
    Object? actualStartTime = freezed,
    Object? actualEndTime = freezed,
    Object? requesterStarted = null,
    Object? providerStarted = null,
  }) {
    return _then(_$SwapSessionImpl(
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      scheduledTime: null == scheduledTime
          ? _value.scheduledTime
          : scheduledTime // ignore: cast_nullable_to_non_nullable
              as String,
      videoLink: null == videoLink
          ? _value.videoLink
          : videoLink // ignore: cast_nullable_to_non_nullable
              as String,
      actualStartTime: freezed == actualStartTime
          ? _value.actualStartTime
          : actualStartTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualEndTime: freezed == actualEndTime
          ? _value.actualEndTime
          : actualEndTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      requesterStarted: null == requesterStarted
          ? _value.requesterStarted
          : requesterStarted // ignore: cast_nullable_to_non_nullable
              as bool,
      providerStarted: null == providerStarted
          ? _value.providerStarted
          : providerStarted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwapSessionImpl implements _SwapSession {
  const _$SwapSessionImpl(
      {@JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required this.scheduledDate,
      this.scheduledTime = '',
      this.videoLink = '',
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      this.actualStartTime,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      this.actualEndTime,
      this.requesterStarted = false,
      this.providerStarted = false});

  factory _$SwapSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwapSessionImplFromJson(json);

  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  final DateTime scheduledDate;
  @override
  @JsonKey()
  final String scheduledTime;
  @override
  @JsonKey()
  final String videoLink;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp)
  final DateTime? actualStartTime;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp)
  final DateTime? actualEndTime;
  @override
  @JsonKey()
  final bool requesterStarted;
  @override
  @JsonKey()
  final bool providerStarted;

  @override
  String toString() {
    return 'SwapSession(scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, videoLink: $videoLink, actualStartTime: $actualStartTime, actualEndTime: $actualEndTime, requesterStarted: $requesterStarted, providerStarted: $providerStarted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapSessionImpl &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.videoLink, videoLink) ||
                other.videoLink == videoLink) &&
            (identical(other.actualStartTime, actualStartTime) ||
                other.actualStartTime == actualStartTime) &&
            (identical(other.actualEndTime, actualEndTime) ||
                other.actualEndTime == actualEndTime) &&
            (identical(other.requesterStarted, requesterStarted) ||
                other.requesterStarted == requesterStarted) &&
            (identical(other.providerStarted, providerStarted) ||
                other.providerStarted == providerStarted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      scheduledDate,
      scheduledTime,
      videoLink,
      actualStartTime,
      actualEndTime,
      requesterStarted,
      providerStarted);

  /// Create a copy of SwapSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapSessionImplCopyWith<_$SwapSessionImpl> get copyWith =>
      __$$SwapSessionImplCopyWithImpl<_$SwapSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwapSessionImplToJson(
      this,
    );
  }
}

abstract class _SwapSession implements SwapSession {
  const factory _SwapSession(
      {@JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required final DateTime scheduledDate,
      final String scheduledTime,
      final String videoLink,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      final DateTime? actualStartTime,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      final DateTime? actualEndTime,
      final bool requesterStarted,
      final bool providerStarted}) = _$SwapSessionImpl;

  factory _SwapSession.fromJson(Map<String, dynamic> json) =
      _$SwapSessionImpl.fromJson;

  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get scheduledDate;
  @override
  String get scheduledTime;
  @override
  String get videoLink;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp)
  DateTime? get actualStartTime;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp)
  DateTime? get actualEndTime;
  @override
  bool get requesterStarted;
  @override
  bool get providerStarted;

  /// Create a copy of SwapSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapSessionImplCopyWith<_$SwapSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SwapRating _$SwapRatingFromJson(Map<String, dynamic> json) {
  return _SwapRating.fromJson(json);
}

/// @nodoc
mixin _$SwapRating {
  String get oderId => throw _privateConstructorUsedError;
  int get stars => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get review => throw _privateConstructorUsedError;
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SwapRating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwapRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapRatingCopyWith<SwapRating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapRatingCopyWith<$Res> {
  factory $SwapRatingCopyWith(
          SwapRating value, $Res Function(SwapRating) then) =
      _$SwapRatingCopyWithImpl<$Res, SwapRating>;
  @useResult
  $Res call(
      {String oderId,
      int stars,
      List<String> tags,
      String review,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime createdAt});
}

/// @nodoc
class _$SwapRatingCopyWithImpl<$Res, $Val extends SwapRating>
    implements $SwapRatingCopyWith<$Res> {
  _$SwapRatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwapRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oderId = null,
    Object? stars = null,
    Object? tags = null,
    Object? review = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      oderId: null == oderId
          ? _value.oderId
          : oderId // ignore: cast_nullable_to_non_nullable
              as String,
      stars: null == stars
          ? _value.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SwapRatingImplCopyWith<$Res>
    implements $SwapRatingCopyWith<$Res> {
  factory _$$SwapRatingImplCopyWith(
          _$SwapRatingImpl value, $Res Function(_$SwapRatingImpl) then) =
      __$$SwapRatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String oderId,
      int stars,
      List<String> tags,
      String review,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime createdAt});
}

/// @nodoc
class __$$SwapRatingImplCopyWithImpl<$Res>
    extends _$SwapRatingCopyWithImpl<$Res, _$SwapRatingImpl>
    implements _$$SwapRatingImplCopyWith<$Res> {
  __$$SwapRatingImplCopyWithImpl(
      _$SwapRatingImpl _value, $Res Function(_$SwapRatingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwapRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oderId = null,
    Object? stars = null,
    Object? tags = null,
    Object? review = null,
    Object? createdAt = null,
  }) {
    return _then(_$SwapRatingImpl(
      oderId: null == oderId
          ? _value.oderId
          : oderId // ignore: cast_nullable_to_non_nullable
              as String,
      stars: null == stars
          ? _value.stars
          : stars // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      review: null == review
          ? _value.review
          : review // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwapRatingImpl implements _SwapRating {
  const _$SwapRatingImpl(
      {required this.oderId,
      required this.stars,
      final List<String> tags = const [],
      this.review = '',
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required this.createdAt})
      : _tags = tags;

  factory _$SwapRatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwapRatingImplFromJson(json);

  @override
  final String oderId;
  @override
  final int stars;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final String review;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  final DateTime createdAt;

  @override
  String toString() {
    return 'SwapRating(oderId: $oderId, stars: $stars, tags: $tags, review: $review, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapRatingImpl &&
            (identical(other.oderId, oderId) || other.oderId == oderId) &&
            (identical(other.stars, stars) || other.stars == stars) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.review, review) || other.review == review) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, oderId, stars,
      const DeepCollectionEquality().hash(_tags), review, createdAt);

  /// Create a copy of SwapRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapRatingImplCopyWith<_$SwapRatingImpl> get copyWith =>
      __$$SwapRatingImplCopyWithImpl<_$SwapRatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwapRatingImplToJson(
      this,
    );
  }
}

abstract class _SwapRating implements SwapRating {
  const factory _SwapRating(
      {required final String oderId,
      required final int stars,
      final List<String> tags,
      final String review,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required final DateTime createdAt}) = _$SwapRatingImpl;

  factory _SwapRating.fromJson(Map<String, dynamic> json) =
      _$SwapRatingImpl.fromJson;

  @override
  String get oderId;
  @override
  int get stars;
  @override
  List<String> get tags;
  @override
  String get review;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get createdAt;

  /// Create a copy of SwapRating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapRatingImplCopyWith<_$SwapRatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SwapModel _$SwapModelFromJson(Map<String, dynamic> json) {
  return _SwapModel.fromJson(json);
}

/// @nodoc
mixin _$SwapModel {
  String get id => throw _privateConstructorUsedError; // Participants
  String get requesterId => throw _privateConstructorUsedError;
  String get requesterName => throw _privateConstructorUsedError;
  String? get requesterPhoto => throw _privateConstructorUsedError;
  String get providerId => throw _privateConstructorUsedError;
  String get providerName => throw _privateConstructorUsedError;
  String? get providerPhoto =>
      throw _privateConstructorUsedError; // Skills being exchanged
  SkillExchange get requesterOffers => throw _privateConstructorUsedError;
  SkillExchange get requesterWants =>
      throw _privateConstructorUsedError; // Terms
  double get duration =>
      throw _privateConstructorUsedError; // in hours (0.5, 1, 1.5, 2)
  double get creditAmount => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError; // Status
  SwapStatus get status =>
      throw _privateConstructorUsedError; // Session (when scheduled)
  SwapSession? get session =>
      throw _privateConstructorUsedError; // Ratings (after completion)
  Map<String, SwapRating> get ratings =>
      throw _privateConstructorUsedError; // Metadata
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp)
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get cancelledBy => throw _privateConstructorUsedError;
  String? get cancelReason => throw _privateConstructorUsedError;

  /// Serializes this SwapModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SwapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SwapModelCopyWith<SwapModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapModelCopyWith<$Res> {
  factory $SwapModelCopyWith(SwapModel value, $Res Function(SwapModel) then) =
      _$SwapModelCopyWithImpl<$Res, SwapModel>;
  @useResult
  $Res call(
      {String id,
      String requesterId,
      String requesterName,
      String? requesterPhoto,
      String providerId,
      String providerName,
      String? providerPhoto,
      SkillExchange requesterOffers,
      SkillExchange requesterWants,
      double duration,
      double creditAmount,
      String message,
      SwapStatus status,
      SwapSession? session,
      Map<String, SwapRating> ratings,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime createdAt,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime updatedAt,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      DateTime? completedAt,
      String? cancelledBy,
      String? cancelReason});

  $SkillExchangeCopyWith<$Res> get requesterOffers;
  $SkillExchangeCopyWith<$Res> get requesterWants;
  $SwapSessionCopyWith<$Res>? get session;
}

/// @nodoc
class _$SwapModelCopyWithImpl<$Res, $Val extends SwapModel>
    implements $SwapModelCopyWith<$Res> {
  _$SwapModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SwapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? requesterName = null,
    Object? requesterPhoto = freezed,
    Object? providerId = null,
    Object? providerName = null,
    Object? providerPhoto = freezed,
    Object? requesterOffers = null,
    Object? requesterWants = null,
    Object? duration = null,
    Object? creditAmount = null,
    Object? message = null,
    Object? status = null,
    Object? session = freezed,
    Object? ratings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? cancelledBy = freezed,
    Object? cancelReason = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      requesterName: null == requesterName
          ? _value.requesterName
          : requesterName // ignore: cast_nullable_to_non_nullable
              as String,
      requesterPhoto: freezed == requesterPhoto
          ? _value.requesterPhoto
          : requesterPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      providerId: null == providerId
          ? _value.providerId
          : providerId // ignore: cast_nullable_to_non_nullable
              as String,
      providerName: null == providerName
          ? _value.providerName
          : providerName // ignore: cast_nullable_to_non_nullable
              as String,
      providerPhoto: freezed == providerPhoto
          ? _value.providerPhoto
          : providerPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      requesterOffers: null == requesterOffers
          ? _value.requesterOffers
          : requesterOffers // ignore: cast_nullable_to_non_nullable
              as SkillExchange,
      requesterWants: null == requesterWants
          ? _value.requesterWants
          : requesterWants // ignore: cast_nullable_to_non_nullable
              as SkillExchange,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double,
      creditAmount: null == creditAmount
          ? _value.creditAmount
          : creditAmount // ignore: cast_nullable_to_non_nullable
              as double,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SwapStatus,
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as SwapSession?,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as Map<String, SwapRating>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of SwapModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SkillExchangeCopyWith<$Res> get requesterOffers {
    return $SkillExchangeCopyWith<$Res>(_value.requesterOffers, (value) {
      return _then(_value.copyWith(requesterOffers: value) as $Val);
    });
  }

  /// Create a copy of SwapModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SkillExchangeCopyWith<$Res> get requesterWants {
    return $SkillExchangeCopyWith<$Res>(_value.requesterWants, (value) {
      return _then(_value.copyWith(requesterWants: value) as $Val);
    });
  }

  /// Create a copy of SwapModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SwapSessionCopyWith<$Res>? get session {
    if (_value.session == null) {
      return null;
    }

    return $SwapSessionCopyWith<$Res>(_value.session!, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SwapModelImplCopyWith<$Res>
    implements $SwapModelCopyWith<$Res> {
  factory _$$SwapModelImplCopyWith(
          _$SwapModelImpl value, $Res Function(_$SwapModelImpl) then) =
      __$$SwapModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requesterId,
      String requesterName,
      String? requesterPhoto,
      String providerId,
      String providerName,
      String? providerPhoto,
      SkillExchange requesterOffers,
      SkillExchange requesterWants,
      double duration,
      double creditAmount,
      String message,
      SwapStatus status,
      SwapSession? session,
      Map<String, SwapRating> ratings,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime createdAt,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      DateTime updatedAt,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      DateTime? completedAt,
      String? cancelledBy,
      String? cancelReason});

  @override
  $SkillExchangeCopyWith<$Res> get requesterOffers;
  @override
  $SkillExchangeCopyWith<$Res> get requesterWants;
  @override
  $SwapSessionCopyWith<$Res>? get session;
}

/// @nodoc
class __$$SwapModelImplCopyWithImpl<$Res>
    extends _$SwapModelCopyWithImpl<$Res, _$SwapModelImpl>
    implements _$$SwapModelImplCopyWith<$Res> {
  __$$SwapModelImplCopyWithImpl(
      _$SwapModelImpl _value, $Res Function(_$SwapModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SwapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? requesterName = null,
    Object? requesterPhoto = freezed,
    Object? providerId = null,
    Object? providerName = null,
    Object? providerPhoto = freezed,
    Object? requesterOffers = null,
    Object? requesterWants = null,
    Object? duration = null,
    Object? creditAmount = null,
    Object? message = null,
    Object? status = null,
    Object? session = freezed,
    Object? ratings = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? cancelledBy = freezed,
    Object? cancelReason = freezed,
  }) {
    return _then(_$SwapModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      requesterName: null == requesterName
          ? _value.requesterName
          : requesterName // ignore: cast_nullable_to_non_nullable
              as String,
      requesterPhoto: freezed == requesterPhoto
          ? _value.requesterPhoto
          : requesterPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      providerId: null == providerId
          ? _value.providerId
          : providerId // ignore: cast_nullable_to_non_nullable
              as String,
      providerName: null == providerName
          ? _value.providerName
          : providerName // ignore: cast_nullable_to_non_nullable
              as String,
      providerPhoto: freezed == providerPhoto
          ? _value.providerPhoto
          : providerPhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      requesterOffers: null == requesterOffers
          ? _value.requesterOffers
          : requesterOffers // ignore: cast_nullable_to_non_nullable
              as SkillExchange,
      requesterWants: null == requesterWants
          ? _value.requesterWants
          : requesterWants // ignore: cast_nullable_to_non_nullable
              as SkillExchange,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as double,
      creditAmount: null == creditAmount
          ? _value.creditAmount
          : creditAmount // ignore: cast_nullable_to_non_nullable
              as double,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SwapStatus,
      session: freezed == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as SwapSession?,
      ratings: null == ratings
          ? _value._ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as Map<String, SwapRating>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelReason: freezed == cancelReason
          ? _value.cancelReason
          : cancelReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SwapModelImpl implements _SwapModel {
  const _$SwapModelImpl(
      {required this.id,
      required this.requesterId,
      required this.requesterName,
      this.requesterPhoto,
      required this.providerId,
      required this.providerName,
      this.providerPhoto,
      required this.requesterOffers,
      required this.requesterWants,
      required this.duration,
      required this.creditAmount,
      this.message = '',
      this.status = SwapStatus.pending,
      this.session,
      final Map<String, SwapRating> ratings = const {},
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required this.createdAt,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required this.updatedAt,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      this.completedAt,
      this.cancelledBy,
      this.cancelReason})
      : _ratings = ratings;

  factory _$SwapModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SwapModelImplFromJson(json);

  @override
  final String id;
// Participants
  @override
  final String requesterId;
  @override
  final String requesterName;
  @override
  final String? requesterPhoto;
  @override
  final String providerId;
  @override
  final String providerName;
  @override
  final String? providerPhoto;
// Skills being exchanged
  @override
  final SkillExchange requesterOffers;
  @override
  final SkillExchange requesterWants;
// Terms
  @override
  final double duration;
// in hours (0.5, 1, 1.5, 2)
  @override
  final double creditAmount;
  @override
  @JsonKey()
  final String message;
// Status
  @override
  @JsonKey()
  final SwapStatus status;
// Session (when scheduled)
  @override
  final SwapSession? session;
// Ratings (after completion)
  final Map<String, SwapRating> _ratings;
// Ratings (after completion)
  @override
  @JsonKey()
  Map<String, SwapRating> get ratings {
    if (_ratings is EqualUnmodifiableMapView) return _ratings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ratings);
  }

// Metadata
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  final DateTime createdAt;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  final DateTime updatedAt;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp)
  final DateTime? completedAt;
  @override
  final String? cancelledBy;
  @override
  final String? cancelReason;

  @override
  String toString() {
    return 'SwapModel(id: $id, requesterId: $requesterId, requesterName: $requesterName, requesterPhoto: $requesterPhoto, providerId: $providerId, providerName: $providerName, providerPhoto: $providerPhoto, requesterOffers: $requesterOffers, requesterWants: $requesterWants, duration: $duration, creditAmount: $creditAmount, message: $message, status: $status, session: $session, ratings: $ratings, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, cancelledBy: $cancelledBy, cancelReason: $cancelReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SwapModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.requesterName, requesterName) ||
                other.requesterName == requesterName) &&
            (identical(other.requesterPhoto, requesterPhoto) ||
                other.requesterPhoto == requesterPhoto) &&
            (identical(other.providerId, providerId) ||
                other.providerId == providerId) &&
            (identical(other.providerName, providerName) ||
                other.providerName == providerName) &&
            (identical(other.providerPhoto, providerPhoto) ||
                other.providerPhoto == providerPhoto) &&
            (identical(other.requesterOffers, requesterOffers) ||
                other.requesterOffers == requesterOffers) &&
            (identical(other.requesterWants, requesterWants) ||
                other.requesterWants == requesterWants) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.creditAmount, creditAmount) ||
                other.creditAmount == creditAmount) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.session, session) || other.session == session) &&
            const DeepCollectionEquality().equals(other._ratings, _ratings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.cancelReason, cancelReason) ||
                other.cancelReason == cancelReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        requesterId,
        requesterName,
        requesterPhoto,
        providerId,
        providerName,
        providerPhoto,
        requesterOffers,
        requesterWants,
        duration,
        creditAmount,
        message,
        status,
        session,
        const DeepCollectionEquality().hash(_ratings),
        createdAt,
        updatedAt,
        completedAt,
        cancelledBy,
        cancelReason
      ]);

  /// Create a copy of SwapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SwapModelImplCopyWith<_$SwapModelImpl> get copyWith =>
      __$$SwapModelImplCopyWithImpl<_$SwapModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SwapModelImplToJson(
      this,
    );
  }
}

abstract class _SwapModel implements SwapModel {
  const factory _SwapModel(
      {required final String id,
      required final String requesterId,
      required final String requesterName,
      final String? requesterPhoto,
      required final String providerId,
      required final String providerName,
      final String? providerPhoto,
      required final SkillExchange requesterOffers,
      required final SkillExchange requesterWants,
      required final double duration,
      required final double creditAmount,
      final String message,
      final SwapStatus status,
      final SwapSession? session,
      final Map<String, SwapRating> ratings,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required final DateTime createdAt,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTimeNonNull,
          toJson: dateTimeToTimestampNonNull)
      required final DateTime updatedAt,
      @JsonKey(
          readValue: readTimestampValue,
          fromJson: timestampToDateTime,
          toJson: dateTimeToTimestamp)
      final DateTime? completedAt,
      final String? cancelledBy,
      final String? cancelReason}) = _$SwapModelImpl;

  factory _SwapModel.fromJson(Map<String, dynamic> json) =
      _$SwapModelImpl.fromJson;

  @override
  String get id; // Participants
  @override
  String get requesterId;
  @override
  String get requesterName;
  @override
  String? get requesterPhoto;
  @override
  String get providerId;
  @override
  String get providerName;
  @override
  String? get providerPhoto; // Skills being exchanged
  @override
  SkillExchange get requesterOffers;
  @override
  SkillExchange get requesterWants; // Terms
  @override
  double get duration; // in hours (0.5, 1, 1.5, 2)
  @override
  double get creditAmount;
  @override
  String get message; // Status
  @override
  SwapStatus get status; // Session (when scheduled)
  @override
  SwapSession? get session; // Ratings (after completion)
  @override
  Map<String, SwapRating> get ratings; // Metadata
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get createdAt;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTimeNonNull,
      toJson: dateTimeToTimestampNonNull)
  DateTime get updatedAt;
  @override
  @JsonKey(
      readValue: readTimestampValue,
      fromJson: timestampToDateTime,
      toJson: dateTimeToTimestamp)
  DateTime? get completedAt;
  @override
  String? get cancelledBy;
  @override
  String? get cancelReason;

  /// Create a copy of SwapModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SwapModelImplCopyWith<_$SwapModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
