// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserChatModel _$UserChatModelFromJson(Map<String, dynamic> json) {
  return _UserChatModel.fromJson(json);
}

/// @nodoc
mixin _$UserChatModel {
  String get id => throw _privateConstructorUsedError;
  String get profilePicture => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<ChatModel> get message => throw _privateConstructorUsedError;
  int get pagination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserChatModelCopyWith<UserChatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserChatModelCopyWith<$Res> {
  factory $UserChatModelCopyWith(
          UserChatModel value, $Res Function(UserChatModel) then) =
      _$UserChatModelCopyWithImpl<$Res, UserChatModel>;
  @useResult
  $Res call(
      {String id,
      String profilePicture,
      String name,
      List<ChatModel> message,
      int pagination});
}

/// @nodoc
class _$UserChatModelCopyWithImpl<$Res, $Val extends UserChatModel>
    implements $UserChatModelCopyWith<$Res> {
  _$UserChatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profilePicture = null,
    Object? name = null,
    Object? message = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profilePicture: null == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as List<ChatModel>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserChatModelImplCopyWith<$Res>
    implements $UserChatModelCopyWith<$Res> {
  factory _$$UserChatModelImplCopyWith(
          _$UserChatModelImpl value, $Res Function(_$UserChatModelImpl) then) =
      __$$UserChatModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String profilePicture,
      String name,
      List<ChatModel> message,
      int pagination});
}

/// @nodoc
class __$$UserChatModelImplCopyWithImpl<$Res>
    extends _$UserChatModelCopyWithImpl<$Res, _$UserChatModelImpl>
    implements _$$UserChatModelImplCopyWith<$Res> {
  __$$UserChatModelImplCopyWithImpl(
      _$UserChatModelImpl _value, $Res Function(_$UserChatModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? profilePicture = null,
    Object? name = null,
    Object? message = null,
    Object? pagination = null,
  }) {
    return _then(_$UserChatModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      profilePicture: null == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value._message
          : message // ignore: cast_nullable_to_non_nullable
              as List<ChatModel>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserChatModelImpl implements _UserChatModel {
  _$UserChatModelImpl(
      {required this.id,
      required this.profilePicture,
      required this.name,
      final List<ChatModel> message = const [],
      this.pagination = 0})
      : _message = message;

  factory _$UserChatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserChatModelImplFromJson(json);

  @override
  final String id;
  @override
  final String profilePicture;
  @override
  final String name;
  final List<ChatModel> _message;
  @override
  @JsonKey()
  List<ChatModel> get message {
    if (_message is EqualUnmodifiableListView) return _message;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_message);
  }

  @override
  @JsonKey()
  final int pagination;

  @override
  String toString() {
    return 'UserChatModel(id: $id, profilePicture: $profilePicture, name: $name, message: $message, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserChatModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._message, _message) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, profilePicture, name,
      const DeepCollectionEquality().hash(_message), pagination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserChatModelImplCopyWith<_$UserChatModelImpl> get copyWith =>
      __$$UserChatModelImplCopyWithImpl<_$UserChatModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserChatModelImplToJson(
      this,
    );
  }
}

abstract class _UserChatModel implements UserChatModel {
  factory _UserChatModel(
      {required final String id,
      required final String profilePicture,
      required final String name,
      final List<ChatModel> message,
      final int pagination}) = _$UserChatModelImpl;

  factory _UserChatModel.fromJson(Map<String, dynamic> json) =
      _$UserChatModelImpl.fromJson;

  @override
  String get id;
  @override
  String get profilePicture;
  @override
  String get name;
  @override
  List<ChatModel> get message;
  @override
  int get pagination;
  @override
  @JsonKey(ignore: true)
  _$$UserChatModelImplCopyWith<_$UserChatModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
