import 'package:freezed_annotation/freezed_annotation.dart';
import 'chapter_model.dart'; // Ajuste o caminho conforme necessário
import 'package:cloud_firestore/cloud_firestore.dart';

part 'item_models.freezed.dart';
part 'item_models.g.dart';

@freezed
class HistoryModel with _$HistoryModel {
  factory HistoryModel({
    required String id,
    required String title,
    required String imagePath,
    required DateTime postData,
    required String categoryId,
    //  @Default([]) List<ChapterModel> chapters,
    // @Default(0) int pagination,
    String? userId,
  }) = _HistoryModel;

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);

  factory HistoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return HistoryModel(
      id: data['id'],
      title: data['title'] ?? '',
      imagePath: data['imagePath'] ?? '',
      postData: (data['postData'] as Timestamp).toDate(),
      categoryId: data['categoryId'],
      /*  chapters: (data['chapters'] as List<dynamic>)
          .map((item) => ChapterModel.fromJson(item as Map<String, dynamic>))
          .toList(),*/
      //: data['pagination'] ?? 0,
      userId: data['userId'] ?? '',
    );
  }
}
