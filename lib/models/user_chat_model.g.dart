// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserChatModelImpl _$$UserChatModelImplFromJson(Map<String, dynamic> json) =>
    _$UserChatModelImpl(
      id: json['id'] as String,
      profilePicture: json['profilePicture'] as String,
      name: json['name'] as String,
      message: (json['message'] as List<dynamic>?)
              ?.map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pagination: (json['pagination'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserChatModelImplToJson(_$UserChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profilePicture': instance.profilePicture,
      'name': instance.name,
      'message': instance.message,
      'pagination': instance.pagination,
    };
