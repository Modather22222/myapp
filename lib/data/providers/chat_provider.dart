
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../../core/api_service.dart';

class Conversation {
  String id;
  String title;
  List<ChatMessage> messages;

  Conversation({required this.id, required this.title, required this.messages});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'],
        title: json['title'],
        messages: (json['messages'] as List)
            .map((item) => ChatMessage.fromJson(item))
            .toList(),
      );
}

class ChatProvider with ChangeNotifier {
  List<Conversation> _conversations = [];
  String? _activeConversationId;
  bool _isLoading = false;
  final Uuid _uuid = const Uuid();

  bool _isNewChatPending = true;

  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;

  bool get isNewChatSession => _activeConversationId == null;

  Conversation? get activeConversation {
    if (_activeConversationId == null) return null;
    try {
      return _conversations.firstWhere((c) => c.id == _activeConversationId);
    } catch (e) {
      return null;
    }
  }

  List<ChatMessage> get messages => activeConversation?.messages ?? [];

  ChatProvider() {
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final conversationsJson = prefs.getString('conversations');
    if (conversationsJson != null) {
      final List<dynamic> conversationsData = jsonDecode(conversationsJson);
      _conversations = conversationsData
          .map((data) => Conversation.fromJson(data))
          .toList();
    }
    notifyListeners();
  }

  Future<void> _saveConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final conversationsJson = jsonEncode(_conversations);
    await prefs.setString('conversations', conversationsJson);
  }

  void startNewConversation() {
    if (isNewChatSession) {
      return;
    }
    _activeConversationId = null;
    _isNewChatPending = true;
    notifyListeners();
  }

  void selectConversation(String id) {
    if (_activeConversationId == id) return;
    _activeConversationId = id;
    _isNewChatPending = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text,
      {String? imagePath, String? filePath}) async {
    if (text.trim().isEmpty && imagePath == null && filePath == null) return;

    final userMessage = ChatMessage(
      text: text,
      sender: MessageSender.user,
      imageUrl: imagePath,
      filePath: filePath,
    );
    Conversation currentConversation;

    if (_isNewChatPending) {
      final newId = _uuid.v4();
      final title =
          imagePath != null ? "Image analysis" : (filePath != null ? "File analysis" : text);
      currentConversation = Conversation(
        id: newId,
        title: title.length > 30 ? title.substring(0, 30) : title,
        messages: [userMessage],
      );
      _conversations.insert(0, currentConversation);
      _activeConversationId = newId;
      _isNewChatPending = false;
    } else {
      currentConversation = activeConversation!;
      currentConversation.messages.add(userMessage);
    }

    _isLoading = true;
    notifyListeners();

    try {
      final aiResponse = await ApiService.getAnswer(text);
      final aiMessage = ChatMessage(text: aiResponse, sender: MessageSender.ai);
      currentConversation.messages.add(aiMessage);
    } catch (e) {
      final errorMessage = ChatMessage(
          text: 'Error: Could not get a response. Please try again.',
          sender: MessageSender.ai);
      currentConversation.messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
      await _saveConversations();
    }
  }
}
