// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brtoon/models/page_chapter_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_model.freezed.dart';
part 'chapter_model.g.dart';

@freezed
class ChapterModel with _$ChapterModel {
  factory ChapterModel({
    required String id,
    required String title,
    required String idHistory,
    required DateTime postData,
    required String imagePath,
    @Default([]) List<PageModel> pages,
    // @Default(0) int pagination,
  }) = _ChapterModel;

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);

  factory ChapterModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ChapterModel(
      id: data['id'],
      title: data['title'] ?? '',
      imagePath: data['imagePath'] ?? '',
      postData: (data['postData'] as Timestamp).toDate(),
      idHistory: data['idHistory'],
      pages: (data['pages'] as List<dynamic>)
          .map((item) => PageModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      //  pagination: data['pagination'] ?? 0,
    );
  }
}
