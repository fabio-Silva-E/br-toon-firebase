// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PageModelImpl _$$PageModelImplFromJson(Map<String, dynamic> json) =>
    _$PageModelImpl(
      id: json['id'] as String,
      chapterId: json['chapterId'] as String,
      imagePath: json['imagePath'] as String,
      postData: DateTime.parse(json['postData'] as String),
    );

Map<String, dynamic> _$$PageModelImplToJson(_$PageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapterId': instance.chapterId,
      'imagePath': instance.imagePath,
      'postData': instance.postData.toIso8601String(),
    };
