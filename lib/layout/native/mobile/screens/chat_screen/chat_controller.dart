import 'package:get/get.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, this.isUser = true});
}

class ChatController extends GetxController {
  var messages = <ChatMessage>[].obs;
  final messageText = ''.obs;

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    messages.add(ChatMessage(text: text, isUser: true));
    messageText.value = '';

    // Fake bot response after 1 second
    Future.delayed(Duration(seconds: 1), () {
      messages.add(ChatMessage(text: 'Reply to "$text"', isUser: false));
    });
  }
}
