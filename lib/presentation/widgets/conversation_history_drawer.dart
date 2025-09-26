
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/chat_provider.dart';

class ConversationHistoryDrawer extends StatelessWidget {
  const ConversationHistoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final conversations = chatProvider.conversations;

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Text(
              'Chat History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final bool isActive =
                    chatProvider.activeConversation?.id == conversation.id;
                return ListTile(
                  title: Text(
                    conversation.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  tileColor: isActive
                      ? Theme.of(context).primaryColor.withAlpha(25)
                      : null,
                  onTap: () {
                    context
                        .read<ChatProvider>()
                        .selectConversation(conversation.id);
                    Navigator.of(context).pop(); // Close the drawer
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1),
            ),
          ),
        ],
      ),
    );
  }
}
