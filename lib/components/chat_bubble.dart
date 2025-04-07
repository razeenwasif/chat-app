import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key, required this.isCurrentUser,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Provider.of<ThemeProvider>(
      context, listen: false
    ).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.red : 
            (isDarkMode ? Color.fromARGB(255, 57, 57, 57) :
               Colors.grey.shade500),
        borderRadius: BorderRadius.circular(12)
      ),
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 25,
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      )
    );
  }
}