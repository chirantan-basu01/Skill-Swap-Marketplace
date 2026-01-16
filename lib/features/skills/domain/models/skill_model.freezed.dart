// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skill_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SkillRef _$SkillRefFromJson(Map<String, dynamic> json) {
  return _SkillRef.fromJson(json);
}

/// @nodoc
mixin _$SkillRef {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this SkillRef to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillRefCopyWith<SkillRef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillRefCopyWith<$Res> {
  factory $SkillRefCopyWith(SkillRef value, $Res Function(SkillRef) then) =
      _$SkillRefCopyWithImpl<$Res, SkillRef>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$SkillRefCopyWithImpl<$Res, $Val extends SkillRef>
    implements $SkillRefCopyWith<$Res> {
  _$SkillRefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkillRefImplCopyWith<$Res>
    implements $SkillRefCopyWith<$Res> {
  factory _$$SkillRefImplCopyWith(
          _$SkillRefImpl value, $Res Function(_$SkillRefImpl) then) =
      __$$SkillRefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$SkillRefImplCopyWithImpl<$Res>
    extends _$SkillRefCopyWithImpl<$Res, _$SkillRefImpl>
    implements _$$SkillRefImplCopyWith<$Res> {
  __$$SkillRefImplCopyWithImpl(
      _$SkillRefImpl _value, $Res Function(_$SkillRefImpl) _then)
      : super(_value, _then);

  /// Create a copy of SkillRef
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$SkillRefImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillRefImpl implements _SkillRef {
  const _$SkillRefImpl({required this.id, required this.name});

  factory _$SkillRefImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillRefImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'SkillRef(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillRefImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of SkillRef
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillRefImplCopyWith<_$SkillRefImpl> get copyWith =>
      __$$SkillRefImplCopyWithImpl<_$SkillRefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillRefImplToJson(
      this,
    );
  }
}

abstract class _SkillRef implements SkillRef {
  const factory _SkillRef(
      {required final String id, required final String name}) = _$SkillRefImpl;

  factory _SkillRef.fromJson(Map<String, dynamic> json) =
      _$SkillRefImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of SkillRef
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillRefImplCopyWith<_$SkillRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkillOffered _$SkillOfferedFromJson(Map<String, dynamic> json) {
  return _SkillOffered.fromJson(json);
}

/// @nodoc
mixin _$SkillOffered {
  String get id => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get skillName => throw _privateConstructorUsedError;
  SkillLevel get level => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this SkillOffered to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillOffered
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillOfferedCopyWith<SkillOffered> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillOfferedCopyWith<$Res> {
  factory $SkillOfferedCopyWith(
          SkillOffered value, $Res Function(SkillOffered) then) =
      _$SkillOfferedCopyWithImpl<$Res, SkillOffered>;
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String categoryName,
      String skillName,
      SkillLevel level,
      String description});
}

/// @nodoc
class _$SkillOfferedCopyWithImpl<$Res, $Val extends SkillOffered>
    implements $SkillOfferedCopyWith<$Res> {
  _$SkillOfferedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillOffered
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? skillName = null,
    Object? level = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkillOfferedImplCopyWith<$Res>
    implements $SkillOfferedCopyWith<$Res> {
  factory _$$SkillOfferedImplCopyWith(
          _$SkillOfferedImpl value, $Res Function(_$SkillOfferedImpl) then) =
      __$$SkillOfferedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String categoryName,
      String skillName,
      SkillLevel level,
      String description});
}

/// @nodoc
class __$$SkillOfferedImplCopyWithImpl<$Res>
    extends _$SkillOfferedCopyWithImpl<$Res, _$SkillOfferedImpl>
    implements _$$SkillOfferedImplCopyWith<$Res> {
  __$$SkillOfferedImplCopyWithImpl(
      _$SkillOfferedImpl _value, $Res Function(_$SkillOfferedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SkillOffered
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? skillName = null,
    Object? level = null,
    Object? description = null,
  }) {
    return _then(_$SkillOfferedImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillOfferedImpl implements _SkillOffered {
  const _$SkillOfferedImpl(
      {required this.id,
      required this.categoryId,
      required this.categoryName,
      required this.skillName,
      required this.level,
      this.description = ''});

  factory _$SkillOfferedImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillOfferedImplFromJson(json);

  @override
  final String id;
  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final String skillName;
  @override
  final SkillLevel level;
  @override
  @JsonKey()
  final String description;

  @override
  String toString() {
    return 'SkillOffered(id: $id, categoryId: $categoryId, categoryName: $categoryName, skillName: $skillName, level: $level, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillOfferedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.skillName, skillName) ||
                other.skillName == skillName) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, categoryId, categoryName, skillName, level, description);

  /// Create a copy of SkillOffered
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillOfferedImplCopyWith<_$SkillOfferedImpl> get copyWith =>
      __$$SkillOfferedImplCopyWithImpl<_$SkillOfferedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillOfferedImplToJson(
      this,
    );
  }
}

abstract class _SkillOffered implements SkillOffered {
  const factory _SkillOffered(
      {required final String id,
      required final String categoryId,
      required final String categoryName,
      required final String skillName,
      required final SkillLevel level,
      final String description}) = _$SkillOfferedImpl;

  factory _SkillOffered.fromJson(Map<String, dynamic> json) =
      _$SkillOfferedImpl.fromJson;

  @override
  String get id;
  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  String get skillName;
  @override
  SkillLevel get level;
  @override
  String get description;

  /// Create a copy of SkillOffered
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillOfferedImplCopyWith<_$SkillOfferedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkillWanted _$SkillWantedFromJson(Map<String, dynamic> json) {
  return _SkillWanted.fromJson(json);
}

/// @nodoc
mixin _$SkillWanted {
  String get id => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get skillName => throw _privateConstructorUsedError;
  SkillLevel get desiredLevel => throw _privateConstructorUsedError;

  /// Serializes this SkillWanted to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillWanted
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillWantedCopyWith<SkillWanted> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillWantedCopyWith<$Res> {
  factory $SkillWantedCopyWith(
          SkillWanted value, $Res Function(SkillWanted) then) =
      _$SkillWantedCopyWithImpl<$Res, SkillWanted>;
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String categoryName,
      String skillName,
      SkillLevel desiredLevel});
}

/// @nodoc
class _$SkillWantedCopyWithImpl<$Res, $Val extends SkillWanted>
    implements $SkillWantedCopyWith<$Res> {
  _$SkillWantedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillWanted
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? skillName = null,
    Object? desiredLevel = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
      desiredLevel: null == desiredLevel
          ? _value.desiredLevel
          : desiredLevel // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkillWantedImplCopyWith<$Res>
    implements $SkillWantedCopyWith<$Res> {
  factory _$$SkillWantedImplCopyWith(
          _$SkillWantedImpl value, $Res Function(_$SkillWantedImpl) then) =
      __$$SkillWantedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String categoryName,
      String skillName,
      SkillLevel desiredLevel});
}

/// @nodoc
class __$$SkillWantedImplCopyWithImpl<$Res>
    extends _$SkillWantedCopyWithImpl<$Res, _$SkillWantedImpl>
    implements _$$SkillWantedImplCopyWith<$Res> {
  __$$SkillWantedImplCopyWithImpl(
      _$SkillWantedImpl _value, $Res Function(_$SkillWantedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SkillWanted
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? skillName = null,
    Object? desiredLevel = null,
  }) {
    return _then(_$SkillWantedImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
      desiredLevel: null == desiredLevel
          ? _value.desiredLevel
          : desiredLevel // ignore: cast_nullable_to_non_nullable
              as SkillLevel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillWantedImpl implements _SkillWanted {
  const _$SkillWantedImpl(
      {required this.id,
      required this.categoryId,
      required this.categoryName,
      required this.skillName,
      this.desiredLevel = SkillLevel.beginner});

  factory _$SkillWantedImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillWantedImplFromJson(json);

  @override
  final String id;
  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final String skillName;
  @override
  @JsonKey()
  final SkillLevel desiredLevel;

  @override
  String toString() {
    return 'SkillWanted(id: $id, categoryId: $categoryId, categoryName: $categoryName, skillName: $skillName, desiredLevel: $desiredLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillWantedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.skillName, skillName) ||
                other.skillName == skillName) &&
            (identical(other.desiredLevel, desiredLevel) ||
                other.desiredLevel == desiredLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, categoryId, categoryName, skillName, desiredLevel);

  /// Create a copy of SkillWanted
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillWantedImplCopyWith<_$SkillWantedImpl> get copyWith =>
      __$$SkillWantedImplCopyWithImpl<_$SkillWantedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillWantedImplToJson(
      this,
    );
  }
}

abstract class _SkillWanted implements SkillWanted {
  const factory _SkillWanted(
      {required final String id,
      required final String categoryId,
      required final String categoryName,
      required final String skillName,
      final SkillLevel desiredLevel}) = _$SkillWantedImpl;

  factory _SkillWanted.fromJson(Map<String, dynamic> json) =
      _$SkillWantedImpl.fromJson;

  @override
  String get id;
  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  String get skillName;
  @override
  SkillLevel get desiredLevel;

  /// Create a copy of SkillWanted
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillWantedImplCopyWith<_$SkillWantedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkillExchange _$SkillExchangeFromJson(Map<String, dynamic> json) {
  return _SkillExchange.fromJson(json);
}

/// @nodoc
mixin _$SkillExchange {
  String get skillId => throw _privateConstructorUsedError;
  String get skillName => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;

  /// Serializes this SkillExchange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillExchange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillExchangeCopyWith<SkillExchange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillExchangeCopyWith<$Res> {
  factory $SkillExchangeCopyWith(
          SkillExchange value, $Res Function(SkillExchange) then) =
      _$SkillExchangeCopyWithImpl<$Res, SkillExchange>;
  @useResult
  $Res call({String skillId, String skillName, String categoryName});
}

/// @nodoc
class _$SkillExchangeCopyWithImpl<$Res, $Val extends SkillExchange>
    implements $SkillExchangeCopyWith<$Res> {
  _$SkillExchangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillExchange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skillId = null,
    Object? skillName = null,
    Object? categoryName = null,
  }) {
    return _then(_value.copyWith(
      skillId: null == skillId
          ? _value.skillId
          : skillId // ignore: cast_nullable_to_non_nullable
              as String,
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkillExchangeImplCopyWith<$Res>
    implements $SkillExchangeCopyWith<$Res> {
  factory _$$SkillExchangeImplCopyWith(
          _$SkillExchangeImpl value, $Res Function(_$SkillExchangeImpl) then) =
      __$$SkillExchangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String skillId, String skillName, String categoryName});
}

/// @nodoc
class __$$SkillExchangeImplCopyWithImpl<$Res>
    extends _$SkillExchangeCopyWithImpl<$Res, _$SkillExchangeImpl>
    implements _$$SkillExchangeImplCopyWith<$Res> {
  __$$SkillExchangeImplCopyWithImpl(
      _$SkillExchangeImpl _value, $Res Function(_$SkillExchangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of SkillExchange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skillId = null,
    Object? skillName = null,
    Object? categoryName = null,
  }) {
    return _then(_$SkillExchangeImpl(
      skillId: null == skillId
          ? _value.skillId
          : skillId // ignore: cast_nullable_to_non_nullable
              as String,
      skillName: null == skillName
          ? _value.skillName
          : skillName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillExchangeImpl implements _SkillExchange {
  const _$SkillExchangeImpl(
      {required this.skillId,
      required this.skillName,
      required this.categoryName});

  factory _$SkillExchangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillExchangeImplFromJson(json);

  @override
  final String skillId;
  @override
  final String skillName;
  @override
  final String categoryName;

  @override
  String toString() {
    return 'SkillExchange(skillId: $skillId, skillName: $skillName, categoryName: $categoryName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillExchangeImpl &&
            (identical(other.skillId, skillId) || other.skillId == skillId) &&
            (identical(other.skillName, skillName) ||
                other.skillName == skillName) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, skillId, skillName, categoryName);

  /// Create a copy of SkillExchange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillExchangeImplCopyWith<_$SkillExchangeImpl> get copyWith =>
      __$$SkillExchangeImplCopyWithImpl<_$SkillExchangeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillExchangeImplToJson(
      this,
    );
  }
}

abstract class _SkillExchange implements SkillExchange {
  const factory _SkillExchange(
      {required final String skillId,
      required final String skillName,
      required final String categoryName}) = _$SkillExchangeImpl;

  factory _SkillExchange.fromJson(Map<String, dynamic> json) =
      _$SkillExchangeImpl.fromJson;

  @override
  String get skillId;
  @override
  String get skillName;
  @override
  String get categoryName;

  /// Create a copy of SkillExchange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillExchangeImplCopyWith<_$SkillExchangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
