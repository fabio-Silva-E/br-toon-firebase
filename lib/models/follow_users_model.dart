import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_users_model.freezed.dart';
part 'follow_users_model.g.dart';

@freezed
class FollowUsersModel with _$FollowUsersModel {
  factory FollowUsersModel({
    String? id,
    String? follower,
    String? followed,
    String? name,
  }) = _FollowUsersModel;

  factory FollowUsersModel.fromJson(Map<String, dynamic> json) =>
      _$FollowUsersModelFromJson(json);

  factory FollowUsersModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FollowUsersModel(
      id: data['id'],
      follower: data['follower'],
      followed: data['followed'],
      name: data['name'],
    );
  }
}
