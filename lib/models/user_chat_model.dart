import 'package:brtoon/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_chat_model.freezed.dart';
part 'user_chat_model.g.dart';

@freezed
class UserChatModel with _$UserChatModel {
  factory UserChatModel({
    required String id,
    required String profilePicture,
    required String name,
    @Default([]) List<ChatModel> message,
    @Default(0) int pagination,
  }) = _UserChatModel;

  factory UserChatModel.fromJson(Map<String, dynamic> json) =>
      _$UserChatModelFromJson(json);

  factory UserChatModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserChatModel(
      id: doc.id,
      profilePicture: data['profilePicture'],
      name: data['name'],
      message: (data['message'] as List<dynamic>?)
              ?.map((item) => ChatModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [], // Handle null case
      pagination: data['pagination'] ?? 0,
    );
  }
}
