import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  final RxList<Map<String, String>> messages = RxList<Map<String, String>>([]);

  void addMessage(String sender, String recipient, String text) {
    print('Adding message for recipient: $recipient'); // Debug print statement
    _messagesCollection.add({
      'sender': sender,
      'recipient': recipient, // Use "recipient" consistently
      'text': text,
      'timestamp': Timestamp.now(),
    }).then((_) {
      messages.add({'sender': sender, 'text': text}); // Update messages locally
      update();
    }).catchError((error) {
      print('Failed to add message: $error');
    });
  }

  final TextEditingController messageController = TextEditingController();
}

class ChatScreen extends GetWidget<ChatController> {
  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    final Map<String, dynamic>? userData =
        Get.arguments as Map<String, dynamic>?;
    final String userId = userData?['uid'] ?? 'Unknown User';
    final String userName = userData?['name'] ?? 'Unknown User';
    final String recipient = userData?['recipient'] ??
        'Unknown Recipient'; // Use "recipient" consistently

    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: chatController.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = chatController.messages[index];
                  final isSender = message['sender'] == userId;
                  final align =
                      isSender ? Alignment.centerRight : Alignment.centerLeft;

                  return Align(
                    alignment: align,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['text']!,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String messageText = chatController.messageController.text;
                    if (messageText.isNotEmpty) {
                      chatController.addMessage(
                        'ZTPykFx4yHRzf6eLpnZXLDzGn2v2',
                        'QeJcblSrGiWvaRdy4ChI6v8oZZ43',
                        messageText,
                      );
                      chatController.messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
