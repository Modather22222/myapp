
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_alt_outlined, // Placeholder for DeepSeek Logo
            size: 64,
            color: theme.primaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Hello, I\'m DeepSeek',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How can I help you today?',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
