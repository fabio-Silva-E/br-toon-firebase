// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brtoon/models/favorite_history_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  factory CategoryModel({
    required String id,
    required String title,
    @Default([]) List<HistoryModel> history,
    @Default([]) List<FavoriteHistoryModel> favorites,
    @Default(0) int pagination,
  }) = _CategoryModel;
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CategoryModel(
      id: doc.id,
      title: data['title'] ?? '',
      history: (data['history'] as List<dynamic>)
          .map((item) => HistoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      favorites: (data['favorites'] as List<dynamic>)
          .map((item) =>
              FavoriteHistoryModel.fromJson(item as Map<String, dynamic>))
          .toList(), // Use an empty list if `favorites` is nulls
      pagination: data['pagination'] ?? 0,
    );
  }
}
