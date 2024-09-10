import 'package:brtoon/models/item_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_history_model.g.dart';
part 'favorite_history_model.freezed.dart';

@freezed
class FavoriteHistoryModel with _$FavoriteHistoryModel {
  factory FavoriteHistoryModel({
    required String favoriteId,
    required HistoryModel history,
    String? user,
  }) = _FavoriteHistoryModel;

  factory FavoriteHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteHistoryModelFromJson(json);

  factory FavoriteHistoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FavoriteHistoryModel(
        favoriteId: doc.id,
        history: HistoryModel.fromJson(data['history'] as Map<String, dynamic>),
        user: data['userId'] ?? '');
  }
}
