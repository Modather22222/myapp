
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/chat_provider.dart';
import '../widgets/conversation_history_drawer.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/empty_state.dart';
import '../widgets/chat_input_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSnackBarVisible = false;

  void _handleNewConversation() {
    final chatProvider = context.read<ChatProvider>();
    if (chatProvider.isNewChatSession) {
      if (!_isSnackBarVisible) {
        setState(() {
          _isSnackBarVisible = true;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                content: Text('You are already in a new chat.'),
                duration: Duration(seconds: 2),
              ),
            )
            .closed
            .then((_) {
          if (mounted) {
            setState(() {
              _isSnackBarVisible = false;
            });
          }
        });
      }
    } else {
      chatProvider.startNewConversation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add_comment_outlined),
          onPressed: _handleNewConversation,
          tooltip: 'New Chat',
        ),
        title: Text(chatProvider.activeConversation?.title ?? 'DeepSeek AI'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: 'Conversations',
            ),
          ),
        ],
      ),
      endDrawer: const ConversationHistoryDrawer(),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.isNewChatSession
                ? const EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return ChatBubble(message: message);
                    },
                  ),
          ),

          if (!chatProvider.isNewChatSession)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ActionChip(
                avatar: Icon(Icons.add_circle_outline, color: theme.textTheme.bodyLarge?.color),
                label: Text(
                  'محادثة جديدة', // "New Conversation" in Arabic
                  style: theme.textTheme.bodyMedium,
                ),
                onPressed: () {
                  context.read<ChatProvider>().startNewConversation();
                },
                backgroundColor: theme.cardColor,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),

          if (chatProvider.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: LinearProgressIndicator(),
            ),
          const ChatInputBar(),
        ],
      ),
    );
  }
}
