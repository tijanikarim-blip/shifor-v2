import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('No messages yet', style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 8),
        Text('Messages from companies will appear here', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ])),
    );
  }
}