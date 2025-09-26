
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/providers/chat_provider.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _textController = TextEditingController();
  String? _attachedImagePath;
  String? _attachedFilePath;

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty &&
        _attachedImagePath == null &&
        _attachedFilePath == null) {
      return;
    }

    final chatProvider = context.read<ChatProvider>();

    await chatProvider.sendMessage(
      text,
      imagePath: _attachedImagePath,
      filePath: _attachedFilePath,
    );

    _textController.clear();
    setState(() {
      _attachedImagePath = null;
      _attachedFilePath = null;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _attachedImagePath = pickedFile.path;
        _attachedFilePath = null;
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc', 'docx', 'md'],
    );
    if (result != null) {
      setState(() {
        _attachedFilePath = result.files.single.path;
        _attachedImagePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Material(
          borderRadius: BorderRadius.circular(28.0),
          elevation: 8.0,
          shadowColor: Colors.black.withAlpha(50),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(28.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_attachedImagePath != null || _attachedFilePath != null)
                  _buildAttachmentPreview(theme),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add, color: theme.iconTheme.color),
                      onPressed: () => _showAttachmentMenu(context),
                      tooltip: 'Attach File or Image',
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Message DeepSeek...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4)
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    chatProvider.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 3)
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: theme.primaryColor,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_upward_rounded),
                              onPressed: _sendMessage,
                              tooltip: 'Send Message',
                              color: Colors.white,
                            ),
                          ),
                    const SizedBox(width: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentPreview(ThemeData theme) {
    File file = File(_attachedImagePath ?? _attachedFilePath!);
    String fileName = file.path.split('/').last;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (_attachedImagePath != null)
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    File(_attachedImagePath!),
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ))
            else
              Icon(Icons.insert_drive_file_outlined, color: theme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                fileName,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                setState(() {
                  _attachedImagePath = null;
                  _attachedFilePath = null;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void _showAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
               ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.black),
                title: const Text('Camera', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.black),
                title: const Text('Gallery', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_file, color: Colors.black),
                title: const Text('Document', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
