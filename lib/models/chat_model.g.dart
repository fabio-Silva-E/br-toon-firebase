// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      sender: UserChatModel.fromJson(json['sender'] as Map<String, dynamic>),
      receiver:
          UserChatModel.fromJson(json['receiver'] as Map<String, dynamic>),
      message: json['message'] as String,
      postData: json['postData'] == null
          ? null
          : DateTime.parse(json['postData'] as String),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'message': instance.message,
      'postData': instance.postData?.toIso8601String(),
    };
