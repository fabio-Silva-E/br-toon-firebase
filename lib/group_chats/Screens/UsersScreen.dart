import 'package:brtoon/base/base_screen.dart';
import 'package:brtoon/group_chats/Screens/ChatRoom.dart';
import 'package:brtoon/group_chats/controller/chat_controller.dart';
import 'package:brtoon/group_chats/group_chat_screen.dart';
import 'package:brtoon/util_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brtoon/followers/controller/folowers_controller.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> with WidgetsBindingObserver {
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _followController = Get.find<FollowController>();
  final utilsServices = UtilsServices();
  ScrollController _scrollController = ScrollController();
  final int _limit = 10;
  String? _lastDocumentName;
  List<DocumentSnapshot> _users = [];

  // Mapa para armazenar o estado de "seguindo" para cada usuário
  Map<String, bool> _followingStatus = {};
  final chatController = Get.find<ChatController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");

    _loadInitialUsers();

    _search.addListener(onSearch);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreUsers();
      }
    });
  }

  Stream<bool> _hasUnreadMessages(String userId) {
    return _firestore
        .collection('chatroom')
        .doc(chatRoomId(userId, _auth.currentUser!.uid))
        .collection('chats')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  @override
  void dispose() {
    _search.removeListener(onSearch);
    _searchFocusNode.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void _loadInitialUsers() async {
    final querySnapshot = await _firestore
        .collection('users')
        .orderBy('name')
        .limit(_limit)
        .get();

    setState(() {
      _users = querySnapshot.docs;
      _lastDocumentName = _users.isNotEmpty ? _users.last['name'] : null;
    });

    // Inicialize o estado de "seguindo" para cada usuário carregado
    for (var userDoc in _users) {
      String userId = userDoc.id;
      await _followController.checkIfFollowing(userId);
      _followingStatus[userId] = _followController.isFollowing.value;
    }

    setState(() {});
  }

  void onSearch() {
    String searchText = _search.text.trim();
    if (searchText.isNotEmpty) {
      String endText = searchText + '\uf8ff';
      _firestore
          .collection('users')
          .orderBy('name')
          .startAt([searchText])
          .endAt([endText])
          .limit(_limit)
          .get()
          .then((querySnapshot) {
            setState(() {
              _users = querySnapshot.docs;
              _lastDocumentName =
                  _users.isNotEmpty ? _users.last['name'] : null;
            });

            // Atualize o estado de "seguindo" para cada usuário filtrado
            for (var userDoc in _users) {
              String userId = userDoc.id;
              _followController.checkIfFollowing(userId).then((_) {
                setState(() {
                  _followingStatus[userId] =
                      _followController.isFollowing.value;
                });
              });
            }
          });
    } else {
      _loadInitialUsers();
    }

    FocusScope.of(context).requestFocus(_searchFocusNode);
  }

  void _loadMoreUsers() {
    if (_lastDocumentName != null) {
      _firestore
          .collection('users')
          .orderBy('name')
          .startAfter([_lastDocumentName])
          .limit(_limit)
          .get()
          .then((querySnapshot) {
            setState(() {
              _users.addAll(querySnapshot.docs);
              _lastDocumentName = querySnapshot.docs.isNotEmpty
                  ? querySnapshot.docs.last['name']
                  : null;
            });

            // Atualize o estado de "seguindo" para os novos usuários carregados
            for (var userDoc in querySnapshot.docs) {
              String userId = userDoc.id;
              _followController.checkIfFollowing(userId).then((_) {
                setState(() {
                  _followingStatus[userId] =
                      _followController.isFollowing.value;
                });
                _loadInitialUsers();
              });
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Comunidade",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 14,
              width: size.width / 1.15,
              child: TextField(
                controller: _search,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: "Procurar...",
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  var user = _users[index].data() as Map<String, dynamic>;
                  String userId = user['uid'];

                  return StreamBuilder<bool>(
                    stream: _hasUnreadMessages(userId),
                    builder: (context, snapshot) {
                      bool hasUnreadMessages = snapshot.data ?? false;
                      if (hasUnreadMessages) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          chatController.updateUnreadMessagesStatus(true);
                        });
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          chatController.updateUnreadMessagesStatus(false);
                        });
                      }
                      return FutureBuilder<String?>(
                        future: _getProfilePictureUrl(userId),
                        builder: (context, snapshot) {
                          String? profilePictureUrl = snapshot.data;

                          return ListTile(
                            onTap: () async {
                              await _followController.checkIfFollowing(userId);
                              if (_followingStatus[userId] ?? false) {
                                setState(() {});
                                String roomId =
                                    chatRoomId(_auth.currentUser!.uid, userId);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatRoom(
                                      chatRoomId: roomId,
                                      userMap: user,
                                    ),
                                  ),
                                );
                              } else {
                                utilsServices.showToast(
                                  message:
                                      'Você deve seguir ${user['name']} para enviar mensagens',
                                  isError: true,
                                );
                              }
                            },
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: profilePictureUrl != null
                                      ? NetworkImage(profilePictureUrl)
                                      : const AssetImage(
                                              'assets/perfil/perfil-de-usuario.png')
                                          as ImageProvider,
                                  radius: 20,
                                ),
                                if (hasUnreadMessages)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(
                              userId == _auth.currentUser!.uid
                                  ? "${user['name']} (Você)"
                                  : user['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(user['email']),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                if (_followingStatus[userId] ?? false) {
                                  await _followController.unFollow(userId);
                                } else {
                                  await _followController.follow(userId);
                                }

                                setState(() {
                                  _followingStatus[userId] =
                                      _followController.isFollowing.value;
                                });
                              },
                              child: Text(
                                _followingStatus[userId] ?? false
                                    ? 'Seguindo'
                                    : 'Seguir',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.group),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const GroupChatHomeScreen(),
          ),
        ),
      ),
    );
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
