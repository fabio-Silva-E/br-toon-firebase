// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_chapter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PageModel _$PageModelFromJson(Map<String, dynamic> json) {
  return _PageModel.fromJson(json);
}

/// @nodoc
mixin _$PageModel {
  String get id => throw _privateConstructorUsedError;
  String get chapterId => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  DateTime get postData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PageModelCopyWith<PageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageModelCopyWith<$Res> {
  factory $PageModelCopyWith(PageModel value, $Res Function(PageModel) then) =
      _$PageModelCopyWithImpl<$Res, PageModel>;
  @useResult
  $Res call({String id, String chapterId, String imagePath, DateTime postData});
}

/// @nodoc
class _$PageModelCopyWithImpl<$Res, $Val extends PageModel>
    implements $PageModelCopyWith<$Res> {
  _$PageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? imagePath = null,
    Object? postData = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      postData: null == postData
          ? _value.postData
          : postData // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageModelImplCopyWith<$Res>
    implements $PageModelCopyWith<$Res> {
  factory _$$PageModelImplCopyWith(
          _$PageModelImpl value, $Res Function(_$PageModelImpl) then) =
      __$$PageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String chapterId, String imagePath, DateTime postData});
}

/// @nodoc
class __$$PageModelImplCopyWithImpl<$Res>
    extends _$PageModelCopyWithImpl<$Res, _$PageModelImpl>
    implements _$$PageModelImplCopyWith<$Res> {
  __$$PageModelImplCopyWithImpl(
      _$PageModelImpl _value, $Res Function(_$PageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chapterId = null,
    Object? imagePath = null,
    Object? postData = null,
  }) {
    return _then(_$PageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      chapterId: null == chapterId
          ? _value.chapterId
          : chapterId // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      postData: null == postData
          ? _value.postData
          : postData // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PageModelImpl implements _PageModel {
  _$PageModelImpl(
      {required this.id,
      required this.chapterId,
      required this.imagePath,
      required this.postData});

  factory _$PageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String chapterId;
  @override
  final String imagePath;
  @override
  final DateTime postData;

  @override
  String toString() {
    return 'PageModel(id: $id, chapterId: $chapterId, imagePath: $imagePath, postData: $postData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chapterId, chapterId) ||
                other.chapterId == chapterId) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.postData, postData) ||
                other.postData == postData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, chapterId, imagePath, postData);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PageModelImplCopyWith<_$PageModelImpl> get copyWith =>
      __$$PageModelImplCopyWithImpl<_$PageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageModelImplToJson(
      this,
    );
  }
}

abstract class _PageModel implements PageModel {
  factory _PageModel(
      {required final String id,
      required final String chapterId,
      required final String imagePath,
      required final DateTime postData}) = _$PageModelImpl;

  factory _PageModel.fromJson(Map<String, dynamic> json) =
      _$PageModelImpl.fromJson;

  @override
  String get id;
  @override
  String get chapterId;
  @override
  String get imagePath;
  @override
  DateTime get postData;
  @override
  @JsonKey(ignore: true)
  _$$PageModelImplCopyWith<_$PageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
