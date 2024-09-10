// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) {
  return _ChapterModel.fromJson(json);
}

/// @nodoc
mixin _$ChapterModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get idHistory => throw _privateConstructorUsedError;
  DateTime get postData => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  List<PageModel> get pages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChapterModelCopyWith<ChapterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChapterModelCopyWith<$Res> {
  factory $ChapterModelCopyWith(
          ChapterModel value, $Res Function(ChapterModel) then) =
      _$ChapterModelCopyWithImpl<$Res, ChapterModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String idHistory,
      DateTime postData,
      String imagePath,
      List<PageModel> pages});
}

/// @nodoc
class _$ChapterModelCopyWithImpl<$Res, $Val extends ChapterModel>
    implements $ChapterModelCopyWith<$Res> {
  _$ChapterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? idHistory = null,
    Object? postData = null,
    Object? imagePath = null,
    Object? pages = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      idHistory: null == idHistory
          ? _value.idHistory
          : idHistory // ignore: cast_nullable_to_non_nullable
              as String,
      postData: null == postData
          ? _value.postData
          : postData // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PageModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChapterModelImplCopyWith<$Res>
    implements $ChapterModelCopyWith<$Res> {
  factory _$$ChapterModelImplCopyWith(
          _$ChapterModelImpl value, $Res Function(_$ChapterModelImpl) then) =
      __$$ChapterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String idHistory,
      DateTime postData,
      String imagePath,
      List<PageModel> pages});
}

/// @nodoc
class __$$ChapterModelImplCopyWithImpl<$Res>
    extends _$ChapterModelCopyWithImpl<$Res, _$ChapterModelImpl>
    implements _$$ChapterModelImplCopyWith<$Res> {
  __$$ChapterModelImplCopyWithImpl(
      _$ChapterModelImpl _value, $Res Function(_$ChapterModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? idHistory = null,
    Object? postData = null,
    Object? imagePath = null,
    Object? pages = null,
  }) {
    return _then(_$ChapterModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      idHistory: null == idHistory
          ? _value.idHistory
          : idHistory // ignore: cast_nullable_to_non_nullable
              as String,
      postData: null == postData
          ? _value.postData
          : postData // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      pages: null == pages
          ? _value._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<PageModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChapterModelImpl implements _ChapterModel {
  _$ChapterModelImpl(
      {required this.id,
      required this.title,
      required this.idHistory,
      required this.postData,
      required this.imagePath,
      final List<PageModel> pages = const []})
      : _pages = pages;

  factory _$ChapterModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChapterModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String idHistory;
  @override
  final DateTime postData;
  @override
  final String imagePath;
  final List<PageModel> _pages;
  @override
  @JsonKey()
  List<PageModel> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
  }

  @override
  String toString() {
    return 'ChapterModel(id: $id, title: $title, idHistory: $idHistory, postData: $postData, imagePath: $imagePath, pages: $pages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChapterModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.idHistory, idHistory) ||
                other.idHistory == idHistory) &&
            (identical(other.postData, postData) ||
                other.postData == postData) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            const DeepCollectionEquality().equals(other._pages, _pages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, idHistory, postData,
      imagePath, const DeepCollectionEquality().hash(_pages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChapterModelImplCopyWith<_$ChapterModelImpl> get copyWith =>
      __$$ChapterModelImplCopyWithImpl<_$ChapterModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChapterModelImplToJson(
      this,
    );
  }
}

abstract class _ChapterModel implements ChapterModel {
  factory _ChapterModel(
      {required final String id,
      required final String title,
      required final String idHistory,
      required final DateTime postData,
      required final String imagePath,
      final List<PageModel> pages}) = _$ChapterModelImpl;

  factory _ChapterModel.fromJson(Map<String, dynamic> json) =
      _$ChapterModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get idHistory;
  @override
  DateTime get postData;
  @override
  String get imagePath;
  @override
  List<PageModel> get pages;
  @override
  @JsonKey(ignore: true)
  _$$ChapterModelImplCopyWith<_$ChapterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
