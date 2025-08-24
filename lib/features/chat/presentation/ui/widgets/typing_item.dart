import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final String conversationId;
  final String otherUserId;

  const TypingIndicator({
    super.key,
    required this.conversationId,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    // reuse conversation stream by embedding tiny one-liner stream
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData || !snap.data!.exists) return const SizedBox.shrink();
        final data = snap.data!.data() as Map<String, dynamic>;
        final typing = Map<String, dynamic>.from(data['typing'] ?? {});
        final otherTyping = typing[otherUserId] == true;
        if (!otherTyping) return const SizedBox.shrink();

        return Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'typing…',
            style: TextStyle(
                fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        );
      },
    );
  }
}
