import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class AuthorProfileController extends GetxController {
  var isLoading = true.obs;
  var userData = Rxn<Map<String, dynamic>>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getUserData(String userId) async {
    try {
      isLoading.value = true;

      // Fetch user data
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        userData.value = userSnapshot.data();
      } else {
        userData.value = null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      userData.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
