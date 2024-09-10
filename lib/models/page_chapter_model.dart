// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_chapter_model.g.dart';
part 'page_chapter_model.freezed.dart';

@freezed
class PageModel with _$PageModel {
  factory PageModel({
    required String id,
    required String chapterId,
    required String imagePath,
    required DateTime postData,
    //  @Default(0) int pagination,
  }) = _PageModel;

  factory PageModel.fromJson(Map<String, dynamic> json) =>
      _$PageModelFromJson(json);

  factory PageModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PageModel(
      id: data['id'],
      imagePath: data['imagePath'] ?? '',
      postData: (data['postData'] as Timestamp).toDate(),
      chapterId: data['chapterId'],
      // pagination: data['pagination'] ?? 0,
    );
  }
}
