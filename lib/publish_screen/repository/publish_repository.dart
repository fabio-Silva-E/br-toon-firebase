import 'package:brtoon/home/result/home_result.dart';
import 'package:brtoon/models/category_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PublishRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Atualiza um capa da historia ja publicada
  Future<String?> updatePublishedHistory(HistoryModel history) async {
    try {
      await _firestore
          .collection('histories')
          .doc(history.id.toString())
          .update(history.toJson()); // Use toJson instead of toMap
      return null; // Retorna null em caso de sucesso
    } on FirebaseException catch (e) {
      return 'Erro ao atualizar história publicada: ${e.message}'; // Retorna a mensagem de erro em caso de falha
    }
  }

  Future<String?> removePublishedHistory(String historyId) async {
    try {
      // Passo 1: Obter todos os capítulos relacionados à história
      QuerySnapshot chaptersSnapshot = await _firestore
          .collection('chapters')
          .where('idHistory', isEqualTo: historyId)
          .get();

      for (QueryDocumentSnapshot chapterDoc in chaptersSnapshot.docs) {
        String chapterId = chapterDoc.id;
        String chapterImagePath = chapterDoc['imagePath'];

        // Passo 2: Obter todas as páginas relacionadas ao capítulo
        QuerySnapshot pagesSnapshot = await _firestore
            .collection('pages')
            .where('chapterId', isEqualTo: chapterId)
            .get();

        for (QueryDocumentSnapshot pageDoc in pagesSnapshot.docs) {
          String pageId = pageDoc.id;
          String pageImagePath = pageDoc['imagePath'];

          // Remover documento da página no Firestore
          await _firestore.collection('pages').doc(pageId).delete();

          // Remover imagem da página no Firebase Storage
          await _storage.refFromURL(pageImagePath).delete();
        }

        // Passo 3: Remover documento do capítulo no Firestore
        await _firestore.collection('chapters').doc(chapterId).delete();

        // Remover imagem do capítulo no Firebase Storage
        await _storage.refFromURL(chapterImagePath).delete();
      }

      // Passo 4: Remover documento da história no Firestore
      DocumentSnapshot historyDoc =
          await _firestore.collection('histories').doc(historyId).get();
      String historyImagePath = historyDoc['imagePath'];
      await _firestore.collection('histories').doc(historyId).delete();

      // Remover imagem da história no Firebase Storage
      await _storage.refFromURL(historyImagePath).delete();

      return 'História, capítulos e páginas removidos com sucesso';
    } on FirebaseException catch (e) {
      return 'Erro ao remover história publicada: ${e.message}';
    }
  }

  Future<DocumentSnapshot> getPublishedHistoryById(String historyId) async {
    return await _firestore.collection('histories').doc(historyId).get();
  }

  // Recupera todas as categorias

  Future<HomeResult<CategoryModel>> fetchAllCategories() async {
    try {
      // Referência para a coleção de categorias
      CollectionReference categoriesRef = _firestore.collection('categories');

      // Obtém os documentos da coleção
      QuerySnapshot querySnapshot = await categoriesRef.get();

      // Mapeia os documentos para CategoryModel
      List<CategoryModel> categories = querySnapshot.docs.map((doc) {
        return CategoryModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return HomeResult<CategoryModel>.success(categories);
    } catch (e) {
      return HomeResult<CategoryModel>.error(
          'Ocorreu um erro inesperado ao recuperar as categorias');
    }
  }
}
