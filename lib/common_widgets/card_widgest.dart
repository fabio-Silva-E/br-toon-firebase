import 'package:brtoon/post_Screen.dart';
import 'package:flutter/material.dart';

class CustomCardWidget extends StatefulWidget {
  final String imageUrl;
  final String itemName;
  final GlobalKey? imageGk;
  final String historyId;
  const CustomCardWidget({
    Key? key,
    required this.imageUrl,
    required this.itemName,
    this.imageGk,
    required this.historyId,
  }) : super(key: key);

  @override
  State<CustomCardWidget> createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {
  void _navigateToPostsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostsScreen(
          storyName: widget.itemName,
          historyId: widget.historyId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Material(
                elevation: 6,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                shadowColor: Colors.grey.shade300,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white54,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.imageUrl,
                      key: widget.imageGk,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _navigateToPostsScreen,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.itemName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Adiciona "..." se o texto for muito longo
                        maxLines: 1, // Limita o texto a uma linha
                        softWrap:
                            false, // Desativa a quebra de linha automática
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.forum, color: Colors.white),
                      onPressed: _navigateToPostsScreen,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
