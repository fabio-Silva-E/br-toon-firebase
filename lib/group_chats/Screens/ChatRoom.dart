import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ChatRoom({required this.chatRoomId, required this.userMap});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    markMessagesAsRead();
  }

  Future<void> markMessagesAsRead() async {
    try {
      final unreadMessages = await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .where('sendby', isNotEqualTo: _auth.currentUser!.uid)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in unreadMessages.docs) {
        await doc.reference.update({'isRead': true});
      }
    } catch (e) {
      print('Erro ao marcar mensagens como lidas: $e');
    }
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": _auth.currentUser!.uid,
      "recipientId": widget.userMap['uid'],
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.uid,
        "message": _message.text,
        "recipientId": widget.userMap['uid'],
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "isRead": false,
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      print("Enter Some Text");
    }
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection("users")
              .doc(widget.userMap['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Row(
                children: [
                  FutureBuilder<String?>(
                    future: _getProfilePictureUrl(widget.userMap['uid']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return CircleAvatar(
                            backgroundImage: NetworkImage(snapshot.data!),
                            radius: 20,
                          );
                        } else {
                          return const CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/perfil/perfil-de-usuario.png'),
                            radius: 20,
                          );
                        }
                      } else {
                        return const CircleAvatar(
                          radius: 20,
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Column(children: [
                    Text(
                      widget.userMap['uid'] == _auth.currentUser!.uid
                          ? "Você"
                          : widget.userMap['name'],
                    ),
                    Text(
                      snapshot.data!['status'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ]),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('chatroom')
                .doc(widget.chatRoomId)
                .collection('chats')
                .orderBy("time", descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Nenhuma mensagem'));
              } else {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> map = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return messages(size, map, context);
                  },
                );
              }
            },
          )),
          Container(
            width: size.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  // Usar Expanded para permitir que o TextField ocupe o máximo de espaço possível
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: size.height /
                          3, // Define um limite máximo para a altura
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: TextField(
                        controller: _message,
                        keyboardType: TextInputType.multiline,
                        maxLines:
                            null, // Permite que o campo expanda em múltiplas linhas
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

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    bool isSentByCurrentUser = map['sendby'] == _auth.currentUser!.uid;
    bool isRead = map['isRead'] ?? true; // Verifica se a mensagem foi lida

    return map['type'] == "text"
        ? Container(
            width: size.width,
            alignment: isSentByCurrentUser
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: isSentByCurrentUser
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                  bottomRight: isSentByCurrentUser
                      ? const Radius.circular(0)
                      : const Radius.circular(15),
                ),
                color: isSentByCurrentUser
                    ? Colors.blue
                    : (isRead
                        ? Colors.grey[300]
                        : Colors.red[100]), // Muda a cor se não foi lida
              ),
              child: Text(
                map['message'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSentByCurrentUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: isSentByCurrentUser
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: map['message'] != ""
                    ? Image.network(
                        map['message'],
                        fit: BoxFit.cover,
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
