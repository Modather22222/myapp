
import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.sender == MessageSender.user;
    final theme = Theme.of(context);

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: isUserMessage
              ? theme.primaryColor.withAlpha(204)
              : theme.colorScheme.secondary.withAlpha(26),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft:
                isUserMessage ? const Radius.circular(20.0) : Radius.zero,
            bottomRight:
                isUserMessage ? Radius.zero : const Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.file(
                  File(message.imageUrl!),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            if (message.filePath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      color: isUserMessage
                          ? Colors.white
                          : theme.textTheme.bodyLarge?.color,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isUserMessage
                              ? Colors.white
                              : theme.textTheme.bodyLarge?.color,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (message.filePath == null && message.text.isNotEmpty)
              Text(
                message.text,
                style: TextStyle(
                  color: isUserMessage
                      ? Colors.white
                      : theme.textTheme.bodyLarge?.color,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
