// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteHistoryModelImpl _$$FavoriteHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FavoriteHistoryModelImpl(
      favoriteId: json['favoriteId'] as String,
      history: HistoryModel.fromJson(json['history'] as Map<String, dynamic>),
      user: json['user'] as String?,
    );

Map<String, dynamic> _$$FavoriteHistoryModelImplToJson(
        _$FavoriteHistoryModelImpl instance) =>
    <String, dynamic>{
      'favoriteId': instance.favoriteId,
      'history': instance.history,
      'user': instance.user,
    };
