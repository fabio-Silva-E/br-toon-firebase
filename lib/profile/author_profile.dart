import 'package:brtoon/common_widgets/anuncios_widget.dart';
import 'package:brtoon/followers/controller/folowers_controller.dart';
import 'package:brtoon/common_widgets/build_text_field.dart';
import 'package:brtoon/profile/controller/author_profile_controller.dart';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilTab extends StatefulWidget {
  final String userId;
  const PerfilTab({required this.userId, super.key});

  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  final followController = Get.find<FollowController>();
  final AuthorProfileController perfilController =
      Get.put(AuthorProfileController());
  bool follow = true;
  final TextEditingController message = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final utilsServices = UtilsServices();

  @override
  void initState() {
    super.initState();
    perfilController.getUserData(widget.userId);
    _checkIsFollow();
  }

  @override
  void didUpdateWidget(PerfilTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != oldWidget) {
      followController.checkIfFollowing(widget.userId);
    }
  }

  Future<void> _checkIsFollow() async {
    await followController.checkIfFollowing(widget.userId);
    setState(() {
      follow = followController.isFollowing.value;
    });
  }

  void onSendMessage() async {
    final userData = perfilController.userData.value;
    if (!follow) {
      if (userData != null && userData['name'] != null) {
        utilsServices.showToast(
          message: 'Você precisa seguir ${userData['name']}',
        );
      } else {
        utilsServices.showToast(
          message: 'Você precisa seguir este usuário',
        );
      }
      return;
    }

    if (message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      message.clear();
      String roomId = chatRoomId(_auth.currentUser!.uid, widget.userId);
      try {
        await _firestore
            .collection('chatroom')
            .doc(roomId)
            .collection('chats')
            .add(messages);

        utilsServices.showToast(
          message: 'Mensagem enviada com sucesso!',
        );
      } catch (e) {
        utilsServices.showToast(
          message: 'Falha ao enviar a mensagem. Tente novamente.',
        );
      }
    } else {
      print("Digite alguma mensagem");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Perfil do autor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Obx(() {
        if (perfilController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = perfilController.userData.value;
        if (userData == null) {
          return const Center(child: Text('Usuário não encontrado.'));
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.blueGrey,
                        child: FutureBuilder<String?>(
                          future: _getProfilePictureUrl(widget.userId),
                          builder: (context, snapshot) {
                            String? profilePictureUrl = snapshot.data;
                            print('foto do autor $profilePictureUrl');
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError || !snapshot.hasData) {
                              return CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.grey[300],
                                child: const Icon(Icons.error),
                              );
                            } else {
                              return CircleAvatar(
                                radius: 65,
                                backgroundImage:
                                    NetworkImage(profilePictureUrl!),
                              );
                            }
                          },
                        ))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            BuildTextField(
              readOnly: true,
              initialValue: userData['email'] ?? '',
              icon: Icons.email,
              label: 'Email',
            ),
            BuildTextField(
              readOnly: true,
              initialValue: userData['name'] ?? '',
              icon: Icons.person,
              label: 'Nome',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (follow) {
                  await followController.unFollow(widget.userId);
                } else {
                  await followController.follow(widget.userId);
                }

                perfilController.getUserData(widget.userId);

                setState(() {
                  follow = !follow;
                });
              },
              child: Text(follow ? 'Deixar de seguir' : 'Seguir'),
            ),
            const SizedBox(height: 20),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: message,
                        minLines: 1,
                        maxLines: 5, // Limite máximo de linhas
                        scrollController: _scrollController,
                        onChanged: (value) {
                          if (message.text.isNotEmpty) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Digite a mensagem...",
                          hintStyle: const TextStyle(color: Colors.white),
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
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: onSendMessage,
                    ),
                  ],
                ),
              ),
            ),
            const AnunciosWidget(
              adUnitId: 'ca-app-pub-4426001722546287/9726196914',
            ),
          ],
        );
      }),
    );
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
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
}
