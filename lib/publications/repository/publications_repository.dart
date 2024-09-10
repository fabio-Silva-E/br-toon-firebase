import 'dart:io';

import 'package:brtoon/models/category_model.dart';
import 'package:brtoon/models/chapter_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:brtoon/models/page_chapter_model.dart';
import 'package:brtoon/publications/result/publications_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PublicationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Adiciona uma nova história publicada
  Future<String?> addPublishedHistory(HistoryModel history) async {
    try {
      // Adiciona o documento na coleção 'histories'
      await _firestore
          .collection('histories')
          .doc(history.id
              .toString()) // Usando o ID da história como o ID do documento
          .set(history.toJson()); // Use toJson instead of toMap

      // Certifique-se de que o ID da história seja retornado após a inserção bem-sucedida

      return history.id;
    } on FirebaseException catch (e) {
      // Retorna a mensagem de erro em caso de falha
      return 'Erro ao adicionar história publicada: ${e.message}';
    }
  }

  // Função para atualizar a capa de uma história publicada
  Future<String?> updatePublishedHistoryCover({
    required String id,
    required String title,
    required DateTime postData,
    required String categoryId,
  }) async {
    try {
      // Passo 1: Upload da nova imagem para o Firebase Storage

      // Passo 2: Atualizar os dados no documento do Firestore
      await _firestore.collection('histories').doc(id).update({
        'title': title,
        'postData': postData.toString(),
        'categoryId': categoryId,
      });

      return 'Capa atualizada com sucesso'; // Retorna null em caso de sucesso
    } on FirebaseException catch (e) {
      return 'Erro ao atualizar a capa da história: ${e.message}'; // Retorna a mensagem de erro em caso de falha
    }
  }

  // Adiciona um capitulo publicado e retorna o ID
  Future<String?> addPublishChapter(ChapterModel chapter) async {
    try {
      print('Adicionando capítulo com ID: ${chapter.id}');
      print('Dados do capítulo: ${chapter.toJson()}');

      await _firestore
          .collection('chapters')
          .doc(chapter.id.toString())
          .set(chapter.toJson());

      print('Capítulo adicionado com sucesso');
      return chapter.id;
    } on FirebaseException catch (e) {
      print('Erro ao adicionar capítulo: ${e.message}');
      return 'Erro ao adicionar capítulo: ${e.message}';
    }
  }

  // Atualiza um capitulo publicado
  Future<String?> updatePublishedChapter({
    required String title,
    required String id,
    required DateTime postData,
  }) async {
    try {
      await _firestore.collection('chapters').doc(id).update({
        'title': title,
        'postData': postData.toString(),
      });
      return 'Capa do capitulo atualizada com sucesso';
    } on FirebaseException catch (e) {
      return 'Erro ao atualizar capitulo publicado: ${e.message}'; // Retorna a mensagem de erro em caso de falha
    }
  }

  Future<DocumentSnapshot> getPublishedChapterById(String chapterId) async {
    return await _firestore.collection('chapters').doc(chapterId).get();
  }

  Future<String?> addPublishPage(PageModel page) async {
    try {
      print('Adicionando página com ID: ${page.id}');
      await _firestore
          .collection('pages')
          .doc(page.id.toString())
          .set(page.toJson());
      print('Página adicionada com sucesso');
      return page.id;
    } on FirebaseException catch (e) {
      print('Erro ao adicionar página: ${e.message}');
      return 'Erro ao adicionar página: ${e.message}';
    }
  }

  Future<String?> updatePublishedPage({
    required String id,
    required DateTime postData,
  }) async {
    try {
      await _firestore.collection('chapters').doc(id).update({
        'postData': postData.toString(),
      });

      return 'Página atualizada com sucesso';
    } on FirebaseException catch (e) {
      return 'Erro ao atualizar página publicada: ${e.message}';
    }
  }

  Future<String?> removePublishedPage(String id, String imagePath) async {
    try {
      // Remove document from Firestore
      await _firestore.collection('pages').doc(id).delete();

      // Remove image from Firebase Storage
      await _storage.refFromURL(imagePath).delete();

      return 'Página removida com sucesso';
    } on FirebaseException catch (e) {
      return 'Erro ao remover página publicada: ${e.message}';
    }
  }

  Future<String?> removePublishedChapter(
      String chapterId, String chapterImagePath) async {
    try {
      // Passo 1: Obter todas as páginas vinculadas ao capítulo
      QuerySnapshot pagesSnapshot = await _firestore
          .collection('pages')
          .where('chapterId', isEqualTo: chapterId)
          .get();

      // Passo 2: Remover cada página encontrada
      for (QueryDocumentSnapshot pageDoc in pagesSnapshot.docs) {
        String pageId = pageDoc.id;
        String pageImagePath = pageDoc['imagePath'];

        // Remover documento da página no Firestore
        await _firestore.collection('pages').doc(pageId).delete();

        // Remover imagem da página no Firebase Storage
        await _storage.refFromURL(pageImagePath).delete();
      }

      // Passo 3: Remover o documento do capítulo no Firestore
      await _firestore.collection('chapters').doc(chapterId).delete();

      // Passo 4: Remover imagem do capítulo no Firebase Storage
      await _storage.refFromURL(chapterImagePath).delete();

      return 'Capítulo e páginas removidos com sucesso';
    } on FirebaseException catch (e) {
      return 'Erro ao remover capítulo publicado: ${e.message}';
    }
  }

  Future<DocumentSnapshot> getPublishedPageById(String page) async {
    return await _firestore.collection('pages').doc(page).get();
  }

  Future<PublicationsResult<CategoryModel>> getAllCategories() async {
    try {
      // Referência para a coleção de categorias
      CollectionReference categoriesRef = _firestore.collection('categories');

      // Obtém os documentos da coleção
      QuerySnapshot querySnapshot = await categoriesRef.get();

      // Mapeia os documentos para CategoryModel
      List<CategoryModel> categories = querySnapshot.docs.map((doc) {
        return CategoryModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return PublicationsResult<CategoryModel>.success(categories);
    } catch (e) {
      return PublicationsResult<CategoryModel>.error(
          'Ocorreu um erro inesperado ao recuperar as categorias');
    }
  }
}
