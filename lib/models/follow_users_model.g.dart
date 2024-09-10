// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FollowUsersModelImpl _$$FollowUsersModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FollowUsersModelImpl(
      id: json['id'] as String?,
      follower: json['follower'] as String?,
      followed: json['followed'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$FollowUsersModelImplToJson(
        _$FollowUsersModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'follower': instance.follower,
      'followed': instance.followed,
      'name': instance.name,
    };
