
enum MessageSender { user, ai }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final String? imageUrl;
  final String? filePath;

  ChatMessage({
    required this.text,
    required this.sender,
    this.imageUrl,
    this.filePath,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'sender': sender.name,
        'imageUrl': imageUrl,
        'filePath': filePath,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        sender: MessageSender.values.firstWhere((e) => e.name == json['sender']),
        imageUrl: json['imageUrl'],
        filePath: json['filePath'],
      );
}
