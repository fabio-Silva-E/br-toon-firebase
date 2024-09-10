// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_model.g.dart';
part 'like_model.freezed.dart';

@freezed
class LikeModel with _$LikeModel {
  factory LikeModel({
    required String userId,
    required String like,
  }) = _LikeModel;

  factory LikeModel.fromJson(Map<String, dynamic> json) =>
      _$LikeModelFromJson(json);

  factory LikeModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return LikeModel(
      userId: data['userId'],
      like: data['like'] ?? '',

      // pagination: data['pagination'] ?? 0,
    );
  }
}
