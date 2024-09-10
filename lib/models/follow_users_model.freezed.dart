// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_users_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FollowUsersModel _$FollowUsersModelFromJson(Map<String, dynamic> json) {
  return _FollowUsersModel.fromJson(json);
}

/// @nodoc
mixin _$FollowUsersModel {
  String? get id => throw _privateConstructorUsedError;
  String? get follower => throw _privateConstructorUsedError;
  String? get followed => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FollowUsersModelCopyWith<FollowUsersModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowUsersModelCopyWith<$Res> {
  factory $FollowUsersModelCopyWith(
          FollowUsersModel value, $Res Function(FollowUsersModel) then) =
      _$FollowUsersModelCopyWithImpl<$Res, FollowUsersModel>;
  @useResult
  $Res call({String? id, String? follower, String? followed, String? name});
}

/// @nodoc
class _$FollowUsersModelCopyWithImpl<$Res, $Val extends FollowUsersModel>
    implements $FollowUsersModelCopyWith<$Res> {
  _$FollowUsersModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? follower = freezed,
    Object? followed = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      follower: freezed == follower
          ? _value.follower
          : follower // ignore: cast_nullable_to_non_nullable
              as String?,
      followed: freezed == followed
          ? _value.followed
          : followed // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowUsersModelImplCopyWith<$Res>
    implements $FollowUsersModelCopyWith<$Res> {
  factory _$$FollowUsersModelImplCopyWith(_$FollowUsersModelImpl value,
          $Res Function(_$FollowUsersModelImpl) then) =
      __$$FollowUsersModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? follower, String? followed, String? name});
}

/// @nodoc
class __$$FollowUsersModelImplCopyWithImpl<$Res>
    extends _$FollowUsersModelCopyWithImpl<$Res, _$FollowUsersModelImpl>
    implements _$$FollowUsersModelImplCopyWith<$Res> {
  __$$FollowUsersModelImplCopyWithImpl(_$FollowUsersModelImpl _value,
      $Res Function(_$FollowUsersModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? follower = freezed,
    Object? followed = freezed,
    Object? name = freezed,
  }) {
    return _then(_$FollowUsersModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      follower: freezed == follower
          ? _value.follower
          : follower // ignore: cast_nullable_to_non_nullable
              as String?,
      followed: freezed == followed
          ? _value.followed
          : followed // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FollowUsersModelImpl implements _FollowUsersModel {
  _$FollowUsersModelImpl({this.id, this.follower, this.followed, this.name});

  factory _$FollowUsersModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowUsersModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? follower;
  @override
  final String? followed;
  @override
  final String? name;

  @override
  String toString() {
    return 'FollowUsersModel(id: $id, follower: $follower, followed: $followed, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowUsersModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.follower, follower) ||
                other.follower == follower) &&
            (identical(other.followed, followed) ||
                other.followed == followed) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, follower, followed, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowUsersModelImplCopyWith<_$FollowUsersModelImpl> get copyWith =>
      __$$FollowUsersModelImplCopyWithImpl<_$FollowUsersModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowUsersModelImplToJson(
      this,
    );
  }
}

abstract class _FollowUsersModel implements FollowUsersModel {
  factory _FollowUsersModel(
      {final String? id,
      final String? follower,
      final String? followed,
      final String? name}) = _$FollowUsersModelImpl;

  factory _FollowUsersModel.fromJson(Map<String, dynamic> json) =
      _$FollowUsersModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get follower;
  @override
  String? get followed;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$FollowUsersModelImplCopyWith<_$FollowUsersModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
