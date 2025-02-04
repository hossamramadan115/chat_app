import 'package:chat_app/constants.dart';
import 'package:chat_app/models/messages.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  static String id = 'chatPage';
  final CollectionReference messages =
      FirebaseFirestore.instance.collection(KMessagesCollection);
  final ScrollController _controller = ScrollController();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
var email = ModalRoute.of(context)!.settings.arguments?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: KPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(kLogo, height: 50),
            const SizedBox(width: 10),
            const Text(
              'Chat',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E2C), Color(0xFF23252B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: messages.orderBy(KCreatedAt, descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Message> messagesList = snapshot.data!.docs
                        .map((doc) => Message.fromjson(doc))
                        .toList();

                    return ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        return messagesList[index].id == email
                            ? ChatBuble(message: messagesList[index])
                            : ChatBubleForFriend(message: messagesList[index]);
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            _buildMessageInput(email),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(String email) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onSubmitted: (data) {
            messages.add({
              KMessage: data,
              KCreatedAt: DateTime.now(),
              KId: email,
            });
            controller.clear();

            _controller.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          },
          decoration: InputDecoration(
            hintText: 'Type your message...',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: KPrimaryColor),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  messages.add({
                    KMessage: controller.text,
                    KCreatedAt: DateTime.now(),
                    KId: email,
                  });
                  controller.clear();
                  _controller.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                }
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}
