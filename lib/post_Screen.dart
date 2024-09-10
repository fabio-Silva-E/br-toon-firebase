import 'dart:io';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PostsScreen extends StatefulWidget {
  final String historyId;
  final String storyName;

  PostsScreen({Key? key, required this.storyName, required this.historyId})
      : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  bool isLoading = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future<String?> _getProfilePictureUrl(String userId) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(userId);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Erro ao buscar a URL da foto de perfil: $e');
      return null;
    }
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('post_message')
        .doc(widget.historyId)
        .collection('messages')
        .doc(fileName)
        .set({
      "sendby": _auth.currentUser!.uid,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('post_message')
          .doc(widget.historyId)
          .collection('messages')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('post_message')
          .doc(widget.historyId)
          .collection('messages')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.uid,
        "message": _messageController.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _messageController.clear();
      await _firestore
          .collection('post_message')
          .doc(widget.historyId)
          .collection('messages')
          .add(messages);

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      print("Digite uma mensagem");
    }
  }

  Stream<QuerySnapshot> _getCommentsStream() {
    return _firestore
        .collection('post_message')
        .doc(widget.historyId)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();
  }

  Widget _buildCommentItem(
      Map<String, dynamic> commentData, String userId, String userName) {
    return FutureBuilder<String?>(
      future: _getProfilePictureUrl(userId),
      builder: (context, snapshot) {
        String? profilePictureUrl = snapshot.data;

        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: profilePictureUrl != null
                        ? NetworkImage(profilePictureUrl)
                        : const AssetImage(
                                'assets/perfil/perfil-de-usuario.png')
                            as ImageProvider,
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              commentData['type'] == "text"
                  ? Text(
                      commentData['message'],
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    )
                  : Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: commentData['message'] != ""
                          ? Image.network(
                              commentData['message'],
                              fit: BoxFit.cover,
                            )
                          : const CircularProgressIndicator(),
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts  ${widget.storyName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getCommentsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var commentData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      String userId = commentData['sendby'];

                      return FutureBuilder<DocumentSnapshot>(
                        future:
                            _firestore.collection('users').doc(userId).get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (userSnapshot.hasData &&
                              userSnapshot.data != null) {
                            var userData = userSnapshot.data!.data()
                                as Map<String, dynamic>;
                            String userName = userData['name'];

                            return _buildCommentItem(
                                commentData, userId, userName);
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Nenhum comentário ainda.'));
                }
              },
            ),
          ),
          Container(
            width: size.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: size.height / 3,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: TextField(
                        controller: _messageController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => getImage(),
                            icon: const Icon(Icons.photo),
                          ),
                          hintText: "Digite a mensagem...",
                          hintStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: onSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
