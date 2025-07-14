import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String timestamp;
  final int chatId;
  final int isSeen;

  ChatMessage({
    required this.text,
    required this.chatId,
    required this.isUser,
    required this.isSeen, required timestamp,
  }) : timestamp = "11,july";
}

class ChatController extends GetxController {
  var messages = <ChatMessage>[].obs;
  final inputController=TextEditingController();
  final messageText = ''.obs;
  var token="".obs;
  final reciever=7.obs;
  Timer? _syncTimer;
  final visibleChatIds = <int>[];
  final lock = Lock();
  @override
  Future<void> onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    final credentials = prefs.getString('credentials');
    final messages_=await CartDatabase.fetchMessages();
    for(ChatMessage chat in messages_){
      messages.add(chat);
    }

    if (credentials != null) {
      final decodedJson = jsonDecode(credentials);
      token.value = decodedJson["token"];
    }
    _syncTimer = Timer.periodic(Duration(seconds: 3), (_) => sync_messages());
  }

  Future<void> sendMessage() async {
    final response=await syncMessages(chatWithId: reciever.value, bearerToken: token.value,newMessage:inputController.text);
    if(response.toString().contains("incomingMessages")){
      final outgoingmessage=ChatMessage(text: inputController.text, chatId: 0, isUser: true, isSeen: 0, timestamp: "11,july",);
      CartDatabase.insertMessage(outgoingmessage);
      messages.add(outgoingmessage);
      inputController.clear();
    }
  }

  Future<void> sync_messages() async {
    final response = await syncMessages(
      chatWithId: reciever.value,
      bearerToken: token.value,
      seenIds: visibleChatIds
    );


    await lock.synchronized(() async {
      for(int chat_m_id in visibleChatIds){
        CartDatabase.updateSeenStatus(messageId: chat_m_id, isSeen: 2);
      }
      visibleChatIds.clear();
    });

    final responseJson = jsonDecode(response.toString());
    final unSeenMessages = responseJson["incomingMessages"] as List;
    final seen_chat_ids = responseJson["theirSeenMessageIds"] as List;
    final deliveredToThemMessageIds = responseJson["deliveredToThemMessageIds"] as List;

    for (var msg in unSeenMessages) {
      final mMessage=ChatMessage(
        text: msg['message'],
        isUser: false,
        chatId: msg["chat_id"],
        isSeen: 1,
        timestamp:msg['created_at'].toString(),
      );
      final insertedChat= await CartDatabase.insertMessage(mMessage);
      messages.add(mMessage);
    }
    ////
    for (var seenId in seen_chat_ids) {
        final idx = messages.indexWhere((m) => m.chatId == seenId);
        if (idx != -1) {
          messages[idx] = ChatMessage(
            text: messages[idx].text,
            chatId: messages[idx].chatId,
            isUser: messages[idx].isUser,
            isSeen: 2,
            timestamp: messages[idx].timestamp,
          );
          CartDatabase.updateSeenStatus(messageId: messages[idx].chatId, isSeen: 2);
        }

    }
    for(var deliveredToThem in deliveredToThemMessageIds){
      final idx = messages.indexWhere((m) => m.chatId ==deliveredToThem);
      if (idx != -1) {
        messages[idx] = ChatMessage(
          text: messages[idx].text,
          chatId: messages[idx].chatId,
          isUser: messages[idx].isUser,
          isSeen: 1,
          timestamp: messages[idx].timestamp,
        );
        CartDatabase.updateSeenStatus(messageId: messages[idx].chatId, isSeen: 1);
      }

    }
  }
  @override
  void onClose() {
    _syncTimer?.cancel();
    super.onClose();
  }


}

/*{"unseenMessages":[{"chat_id":1,"sender_id":6,"receiver_id":6,"message":"i m ranjan","seen":0,"timestamp":"2025-07-13 09:57:23"}],"mySeenMessageIds":[]}*/
