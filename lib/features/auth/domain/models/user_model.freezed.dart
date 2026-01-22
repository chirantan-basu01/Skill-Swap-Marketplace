// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserRating _$UserRatingFromJson(Map<String, dynamic> json) {
  return _UserRating.fromJson(json);
}

/// @nodoc
mixin _$UserRating {
  double get average => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  Map<String, int> get tags => throw _privateConstructorUsedError;

  /// Serializes this UserRating to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRatingCopyWith<UserRating> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRatingCopyWith<$Res> {
  factory $UserRatingCopyWith(
          UserRating value, $Res Function(UserRating) then) =
      _$UserRatingCopyWithImpl<$Res, UserRating>;
  @useResult
  $Res call({double average, int count, Map<String, int> tags});
}

/// @nodoc
class _$UserRatingCopyWithImpl<$Res, $Val extends UserRating>
    implements $UserRatingCopyWith<$Res> {
  _$UserRatingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? average = null,
    Object? count = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      average: null == average
          ? _value.average
          : average // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRatingImplCopyWith<$Res>
    implements $UserRatingCopyWith<$Res> {
  factory _$$UserRatingImplCopyWith(
          _$UserRatingImpl value, $Res Function(_$UserRatingImpl) then) =
      __$$UserRatingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double average, int count, Map<String, int> tags});
}

/// @nodoc
class __$$UserRatingImplCopyWithImpl<$Res>
    extends _$UserRatingCopyWithImpl<$Res, _$UserRatingImpl>
    implements _$$UserRatingImplCopyWith<$Res> {
  __$$UserRatingImplCopyWithImpl(
      _$UserRatingImpl _value, $Res Function(_$UserRatingImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserRating
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? average = null,
    Object? count = null,
    Object? tags = null,
  }) {
    return _then(_$UserRatingImpl(
      average: null == average
          ? _value.average
          : average // ignore: cast_nullable_to_non_nullable
              as double,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRatingImpl implements _UserRating {
  const _$UserRatingImpl(
      {this.average = 0.0,
      this.count = 0,
      final Map<String, int> tags = const {}})
      : _tags = tags;

  factory _$UserRatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRatingImplFromJson(json);

  @override
  @JsonKey()
  final double average;
  @override
  @JsonKey()
  final int count;
  final Map<String, int> _tags;
  @override
  @JsonKey()
  Map<String, int> get tags {
    if (_tags is EqualUnmodifiableMapView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tags);
  }

  @override
  String toString() {
    return 'UserRating(average: $average, count: $count, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRatingImpl &&
            (identical(other.average, average) || other.average == average) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, average, count, const DeepCollectionEquality().hash(_tags));

  /// Create a copy of UserRating
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRatingImplCopyWith<_$UserRatingImpl> get copyWith =>
      __$$UserRatingImplCopyWithImpl<_$UserRatingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRatingImplToJson(
      this,
    );
  }
}

abstract class _UserRating implements UserRating {
  const factory _UserRating(
      {final double average,
      final int count,
      final Map<String, int> tags}) = _$UserRatingImpl;

  factory _UserRating.fromJson(Map<String, dynamic> json) =
      _$UserRatingImpl.fromJson;

  @override
  double get average;
  @override
  int get count;
  @override
  Map<String, int> get tags;

  /// Create a copy of UserRating
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRatingImplCopyWith<_$UserRatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError; // Skills
  List<SkillOffered> get skillsOffered => throw _privateConstructorUsedError;
  List<SkillWanted> get skillsWanted =>
      throw _privateConstructorUsedError; // Availability
  String get timezone => throw _privateConstructorUsedError;
  Availability get availability => throw _privateConstructorUsedError; // Stats
  double get creditBalance => throw _privateConstructorUsedError;
  int get swapsCompleted => throw _privateConstructorUsedError;
  double get hoursExchanged => throw _privateConstructorUsedError; // Rating
  UserRating get rating => throw _privateConstructorUsedError; // Status
  UserStatus get status => throw _privateConstructorUsedError; // Timestamps
  @TimestampConverterNonNull()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverterNonNull()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @TimestampConverterNonNull()
  DateTime get lastActiveAt =>
      throw _privateConstructorUsedError; // New user limits
  @TimestampConverter()
  DateTime? get firstSwapDate => throw _privateConstructorUsedError;
  int get swapsThisWeek => throw _privateConstructorUsedError; // Blocked users
  List<String> get blockedUsers => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String uid,
      String email,
      bool emailVerified,
      String displayName,
      String? photoUrl,
      String bio,
      List<SkillOffered> skillsOffered,
      List<SkillWanted> skillsWanted,
      String timezone,
      Availability availability,
      double creditBalance,
      int swapsCompleted,
      double hoursExchanged,
      UserRating rating,
      UserStatus status,
      @TimestampConverterNonNull() DateTime createdAt,
      @TimestampConverterNonNull() DateTime updatedAt,
      @TimestampConverterNonNull() DateTime lastActiveAt,
      @TimestampConverter() DateTime? firstSwapDate,
      int swapsThisWeek,
      List<String> blockedUsers});

  $UserRatingCopyWith<$Res> get rating;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? emailVerified = null,
    Object? displayName = null,
    Object? photoUrl = freezed,
    Object? bio = null,
    Object? skillsOffered = null,
    Object? skillsWanted = null,
    Object? timezone = null,
    Object? availability = null,
    Object? creditBalance = null,
    Object? swapsCompleted = null,
    Object? hoursExchanged = null,
    Object? rating = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastActiveAt = null,
    Object? firstSwapDate = freezed,
    Object? swapsThisWeek = null,
    Object? blockedUsers = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      skillsOffered: null == skillsOffered
          ? _value.skillsOffered
          : skillsOffered // ignore: cast_nullable_to_non_nullable
              as List<SkillOffered>,
      skillsWanted: null == skillsWanted
          ? _value.skillsWanted
          : skillsWanted // ignore: cast_nullable_to_non_nullable
              as List<SkillWanted>,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      availability: null == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as Availability,
      creditBalance: null == creditBalance
          ? _value.creditBalance
          : creditBalance // ignore: cast_nullable_to_non_nullable
              as double,
      swapsCompleted: null == swapsCompleted
          ? _value.swapsCompleted
          : swapsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      hoursExchanged: null == hoursExchanged
          ? _value.hoursExchanged
          : hoursExchanged // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as UserRating,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActiveAt: null == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      firstSwapDate: freezed == firstSwapDate
          ? _value.firstSwapDate
          : firstSwapDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      swapsThisWeek: null == swapsThisWeek
          ? _value.swapsThisWeek
          : swapsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      blockedUsers: null == blockedUsers
          ? _value.blockedUsers
          : blockedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserRatingCopyWith<$Res> get rating {
    return $UserRatingCopyWith<$Res>(_value.rating, (value) {
      return _then(_value.copyWith(rating: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      bool emailVerified,
      String displayName,
      String? photoUrl,
      String bio,
      List<SkillOffered> skillsOffered,
      List<SkillWanted> skillsWanted,
      String timezone,
      Availability availability,
      double creditBalance,
      int swapsCompleted,
      double hoursExchanged,
      UserRating rating,
      UserStatus status,
      @TimestampConverterNonNull() DateTime createdAt,
      @TimestampConverterNonNull() DateTime updatedAt,
      @TimestampConverterNonNull() DateTime lastActiveAt,
      @TimestampConverter() DateTime? firstSwapDate,
      int swapsThisWeek,
      List<String> blockedUsers});

  @override
  $UserRatingCopyWith<$Res> get rating;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? emailVerified = null,
    Object? displayName = null,
    Object? photoUrl = freezed,
    Object? bio = null,
    Object? skillsOffered = null,
    Object? skillsWanted = null,
    Object? timezone = null,
    Object? availability = null,
    Object? creditBalance = null,
    Object? swapsCompleted = null,
    Object? hoursExchanged = null,
    Object? rating = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastActiveAt = null,
    Object? firstSwapDate = freezed,
    Object? swapsThisWeek = null,
    Object? blockedUsers = null,
  }) {
    return _then(_$UserModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      skillsOffered: null == skillsOffered
          ? _value._skillsOffered
          : skillsOffered // ignore: cast_nullable_to_non_nullable
              as List<SkillOffered>,
      skillsWanted: null == skillsWanted
          ? _value._skillsWanted
          : skillsWanted // ignore: cast_nullable_to_non_nullable
              as List<SkillWanted>,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      availability: null == availability
          ? _value.availability
          : availability // ignore: cast_nullable_to_non_nullable
              as Availability,
      creditBalance: null == creditBalance
          ? _value.creditBalance
          : creditBalance // ignore: cast_nullable_to_non_nullable
              as double,
      swapsCompleted: null == swapsCompleted
          ? _value.swapsCompleted
          : swapsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      hoursExchanged: null == hoursExchanged
          ? _value.hoursExchanged
          : hoursExchanged // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as UserRating,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActiveAt: null == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      firstSwapDate: freezed == firstSwapDate
          ? _value.firstSwapDate
          : firstSwapDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      swapsThisWeek: null == swapsThisWeek
          ? _value.swapsThisWeek
          : swapsThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      blockedUsers: null == blockedUsers
          ? _value._blockedUsers
          : blockedUsers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.uid,
      required this.email,
      this.emailVerified = false,
      required this.displayName,
      this.photoUrl,
      this.bio = '',
      final List<SkillOffered> skillsOffered = const [],
      final List<SkillWanted> skillsWanted = const [],
      this.timezone = '',
      this.availability = Availability.flexible,
      this.creditBalance = 1.0,
      this.swapsCompleted = 0,
      this.hoursExchanged = 0.0,
      this.rating = const UserRating(),
      this.status = UserStatus.active,
      @TimestampConverterNonNull() required this.createdAt,
      @TimestampConverterNonNull() required this.updatedAt,
      @TimestampConverterNonNull() required this.lastActiveAt,
      @TimestampConverter() this.firstSwapDate,
      this.swapsThisWeek = 0,
      final List<String> blockedUsers = const []})
      : _skillsOffered = skillsOffered,
        _skillsWanted = skillsWanted,
        _blockedUsers = blockedUsers;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  @JsonKey()
  final bool emailVerified;
  @override
  final String displayName;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  final String bio;
// Skills
  final List<SkillOffered> _skillsOffered;
// Skills
  @override
  @JsonKey()
  List<SkillOffered> get skillsOffered {
    if (_skillsOffered is EqualUnmodifiableListView) return _skillsOffered;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsOffered);
  }

  final List<SkillWanted> _skillsWanted;
  @override
  @JsonKey()
  List<SkillWanted> get skillsWanted {
    if (_skillsWanted is EqualUnmodifiableListView) return _skillsWanted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsWanted);
  }

// Availability
  @override
  @JsonKey()
  final String timezone;
  @override
  @JsonKey()
  final Availability availability;
// Stats
  @override
  @JsonKey()
  final double creditBalance;
  @override
  @JsonKey()
  final int swapsCompleted;
  @override
  @JsonKey()
  final double hoursExchanged;
// Rating
  @override
  @JsonKey()
  final UserRating rating;
// Status
  @override
  @JsonKey()
  final UserStatus status;
// Timestamps
  @override
  @TimestampConverterNonNull()
  final DateTime createdAt;
  @override
  @TimestampConverterNonNull()
  final DateTime updatedAt;
  @override
  @TimestampConverterNonNull()
  final DateTime lastActiveAt;
// New user limits
  @override
  @TimestampConverter()
  final DateTime? firstSwapDate;
  @override
  @JsonKey()
  final int swapsThisWeek;
// Blocked users
  final List<String> _blockedUsers;
// Blocked users
  @override
  @JsonKey()
  List<String> get blockedUsers {
    if (_blockedUsers is EqualUnmodifiableListView) return _blockedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockedUsers);
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, emailVerified: $emailVerified, displayName: $displayName, photoUrl: $photoUrl, bio: $bio, skillsOffered: $skillsOffered, skillsWanted: $skillsWanted, timezone: $timezone, availability: $availability, creditBalance: $creditBalance, swapsCompleted: $swapsCompleted, hoursExchanged: $hoursExchanged, rating: $rating, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, lastActiveAt: $lastActiveAt, firstSwapDate: $firstSwapDate, swapsThisWeek: $swapsThisWeek, blockedUsers: $blockedUsers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other._skillsOffered, _skillsOffered) &&
            const DeepCollectionEquality()
                .equals(other._skillsWanted, _skillsWanted) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.creditBalance, creditBalance) ||
                other.creditBalance == creditBalance) &&
            (identical(other.swapsCompleted, swapsCompleted) ||
                other.swapsCompleted == swapsCompleted) &&
            (identical(other.hoursExchanged, hoursExchanged) ||
                other.hoursExchanged == hoursExchanged) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            (identical(other.firstSwapDate, firstSwapDate) ||
                other.firstSwapDate == firstSwapDate) &&
            (identical(other.swapsThisWeek, swapsThisWeek) ||
                other.swapsThisWeek == swapsThisWeek) &&
            const DeepCollectionEquality()
                .equals(other._blockedUsers, _blockedUsers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uid,
        email,
        emailVerified,
        displayName,
        photoUrl,
        bio,
        const DeepCollectionEquality().hash(_skillsOffered),
        const DeepCollectionEquality().hash(_skillsWanted),
        timezone,
        availability,
        creditBalance,
        swapsCompleted,
        hoursExchanged,
        rating,
        status,
        createdAt,
        updatedAt,
        lastActiveAt,
        firstSwapDate,
        swapsThisWeek,
        const DeepCollectionEquality().hash(_blockedUsers)
      ]);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final String uid,
      required final String email,
      final bool emailVerified,
      required final String displayName,
      final String? photoUrl,
      final String bio,
      final List<SkillOffered> skillsOffered,
      final List<SkillWanted> skillsWanted,
      final String timezone,
      final Availability availability,
      final double creditBalance,
      final int swapsCompleted,
      final double hoursExchanged,
      final UserRating rating,
      final UserStatus status,
      @TimestampConverterNonNull() required final DateTime createdAt,
      @TimestampConverterNonNull() required final DateTime updatedAt,
      @TimestampConverterNonNull() required final DateTime lastActiveAt,
      @TimestampConverter() final DateTime? firstSwapDate,
      final int swapsThisWeek,
      final List<String> blockedUsers}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  bool get emailVerified;
  @override
  String get displayName;
  @override
  String? get photoUrl;
  @override
  String get bio; // Skills
  @override
  List<SkillOffered> get skillsOffered;
  @override
  List<SkillWanted> get skillsWanted; // Availability
  @override
  String get timezone;
  @override
  Availability get availability; // Stats
  @override
  double get creditBalance;
  @override
  int get swapsCompleted;
  @override
  double get hoursExchanged; // Rating
  @override
  UserRating get rating; // Status
  @override
  UserStatus get status; // Timestamps
  @override
  @TimestampConverterNonNull()
  DateTime get createdAt;
  @override
  @TimestampConverterNonNull()
  DateTime get updatedAt;
  @override
  @TimestampConverterNonNull()
  DateTime get lastActiveAt; // New user limits
  @override
  @TimestampConverter()
  DateTime? get firstSwapDate;
  @override
  int get swapsThisWeek; // Blocked users
  @override
  List<String> get blockedUsers;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
