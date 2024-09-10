import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_chat_model.dart'; // Certifique-se de importar UserChatModel

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  factory ChatModel({
    required UserChatModel sender,
    required UserChatModel receiver,
    required String message,
    DateTime? postData,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ChatModel(
      sender: UserChatModel.fromFirestore(data['followId']),
      receiver: UserChatModel.fromFirestore(data['followedId']),
      message: data['message'] ?? '',
      postData: (data['postData'] as Timestamp?)?.toDate(),
    );
  }
}
