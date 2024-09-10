// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterModelImpl _$$ChapterModelImplFromJson(Map<String, dynamic> json) =>
    _$ChapterModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      idHistory: json['idHistory'] as String,
      postData: DateTime.parse(json['postData'] as String),
      imagePath: json['imagePath'] as String,
      pages: (json['pages'] as List<dynamic>?)
              ?.map((e) => PageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChapterModelImplToJson(_$ChapterModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'idHistory': instance.idHistory,
      'postData': instance.postData.toIso8601String(),
      'imagePath': instance.imagePath,
      'pages': instance.pages,
    };
