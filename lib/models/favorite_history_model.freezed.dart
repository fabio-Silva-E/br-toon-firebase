// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FavoriteHistoryModel _$FavoriteHistoryModelFromJson(Map<String, dynamic> json) {
  return _FavoriteHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$FavoriteHistoryModel {
  String get favoriteId => throw _privateConstructorUsedError;
  HistoryModel get history => throw _privateConstructorUsedError;
  String? get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FavoriteHistoryModelCopyWith<FavoriteHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteHistoryModelCopyWith<$Res> {
  factory $FavoriteHistoryModelCopyWith(FavoriteHistoryModel value,
          $Res Function(FavoriteHistoryModel) then) =
      _$FavoriteHistoryModelCopyWithImpl<$Res, FavoriteHistoryModel>;
  @useResult
  $Res call({String favoriteId, HistoryModel history, String? user});

  $HistoryModelCopyWith<$Res> get history;
}

/// @nodoc
class _$FavoriteHistoryModelCopyWithImpl<$Res,
        $Val extends FavoriteHistoryModel>
    implements $FavoriteHistoryModelCopyWith<$Res> {
  _$FavoriteHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? favoriteId = null,
    Object? history = null,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      favoriteId: null == favoriteId
          ? _value.favoriteId
          : favoriteId // ignore: cast_nullable_to_non_nullable
              as String,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as HistoryModel,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HistoryModelCopyWith<$Res> get history {
    return $HistoryModelCopyWith<$Res>(_value.history, (value) {
      return _then(_value.copyWith(history: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FavoriteHistoryModelImplCopyWith<$Res>
    implements $FavoriteHistoryModelCopyWith<$Res> {
  factory _$$FavoriteHistoryModelImplCopyWith(_$FavoriteHistoryModelImpl value,
          $Res Function(_$FavoriteHistoryModelImpl) then) =
      __$$FavoriteHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String favoriteId, HistoryModel history, String? user});

  @override
  $HistoryModelCopyWith<$Res> get history;
}

/// @nodoc
class __$$FavoriteHistoryModelImplCopyWithImpl<$Res>
    extends _$FavoriteHistoryModelCopyWithImpl<$Res, _$FavoriteHistoryModelImpl>
    implements _$$FavoriteHistoryModelImplCopyWith<$Res> {
  __$$FavoriteHistoryModelImplCopyWithImpl(_$FavoriteHistoryModelImpl _value,
      $Res Function(_$FavoriteHistoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? favoriteId = null,
    Object? history = null,
    Object? user = freezed,
  }) {
    return _then(_$FavoriteHistoryModelImpl(
      favoriteId: null == favoriteId
          ? _value.favoriteId
          : favoriteId // ignore: cast_nullable_to_non_nullable
              as String,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as HistoryModel,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteHistoryModelImpl implements _FavoriteHistoryModel {
  _$FavoriteHistoryModelImpl(
      {required this.favoriteId, required this.history, this.user});

  factory _$FavoriteHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteHistoryModelImplFromJson(json);

  @override
  final String favoriteId;
  @override
  final HistoryModel history;
  @override
  final String? user;

  @override
  String toString() {
    return 'FavoriteHistoryModel(favoriteId: $favoriteId, history: $history, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteHistoryModelImpl &&
            (identical(other.favoriteId, favoriteId) ||
                other.favoriteId == favoriteId) &&
            (identical(other.history, history) || other.history == history) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, favoriteId, history, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteHistoryModelImplCopyWith<_$FavoriteHistoryModelImpl>
      get copyWith =>
          __$$FavoriteHistoryModelImplCopyWithImpl<_$FavoriteHistoryModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _FavoriteHistoryModel implements FavoriteHistoryModel {
  factory _FavoriteHistoryModel(
      {required final String favoriteId,
      required final HistoryModel history,
      final String? user}) = _$FavoriteHistoryModelImpl;

  factory _FavoriteHistoryModel.fromJson(Map<String, dynamic> json) =
      _$FavoriteHistoryModelImpl.fromJson;

  @override
  String get favoriteId;
  @override
  HistoryModel get history;
  @override
  String? get user;
  @override
  @JsonKey(ignore: true)
  _$$FavoriteHistoryModelImplCopyWith<_$FavoriteHistoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
