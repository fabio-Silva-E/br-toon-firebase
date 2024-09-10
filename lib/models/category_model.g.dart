// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      favorites: (json['favorites'] as List<dynamic>?)
              ?.map((e) =>
                  FavoriteHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pagination: (json['pagination'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'history': instance.history,
      'favorites': instance.favorites,
      'pagination': instance.pagination,
    };
