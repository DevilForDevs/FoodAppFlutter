import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/networkings.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final visibleChatIds=<int>[];
  final inputController=TextEditingController();
  final messageText = ''.obs;
  var token="".obs;
  final reciever=6.obs;
  Timer? _syncTimer;
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
    final responseJson=jsonDecode(response.toString());

    if(responseJson.containsKey('insertedChatId')){
      if(responseJson["insertedChatId"]==-1){
        print("server failure");
      }else{
        final outgoingmessage=ChatMessage(text: inputController.text, chatId:responseJson["insertedChatId"], isUser: true, isSeen: 0, timestamp: "11,july",);
        CartDatabase.insertMessage(outgoingmessage);
        messages.add(outgoingmessage);
        inputController.clear();
      }

    }


  }
  Future<void> openDialPad() async {
    final Uri uri = Uri(scheme: 'tel', path: "7632975366");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<void> sendSeenIds(int chatId)async{
    final response = await syncMessages(
        chatWithId: reciever.value,
        bearerToken: token.value,
        seenIds: [chatId]
    );
    CartDatabase.updateSeenStatus(messageId: chatId, isSeen: 2);
  }

  Future<void> sync_messages() async {
    late List<int> seenIdsCopy;

    await lock.synchronized(() {
      // Safely copy visibleChatIds
      seenIdsCopy = List<int>.from(visibleChatIds);
      // Clear immediately so we don't send them again
      visibleChatIds.clear();
    });

    // Now use the snapshot safely outside the lock
    final response = await syncMessages(
      chatWithId: reciever.value,
      bearerToken: token.value,
      seenIds: seenIdsCopy,
    );

    // Optionally update local database
    for (int m_chat_id in seenIdsCopy) {
      CartDatabase.updateSeenStatus(messageId: m_chat_id, isSeen: 2);
    }

    final responseJson = jsonDecode(response.toString());
    final List<dynamic> unSeenMessages = responseJson["serverToDeviceMessage"] as List<dynamic>? ?? [];
    final List<dynamic> seen_chat_ids = responseJson["theirSeenMessageIds"] as List<dynamic>? ?? [];
    final List<dynamic> deliveredToThemMessageIds = responseJson["deliveredToThemMessageIds"] as List<dynamic>? ?? [];


    for (var msg in unSeenMessages) {
      final mMessage=ChatMessage(
        text: msg['message'],
        isUser: false,
        chatId: msg["chat_id"],
        isSeen: 1,
        timestamp:msg['created_at'].toString(),
      );
      print(msg);
      print("++++++++++++++++++++++++++++");
      final insertedChat= await CartDatabase.insertMessage(mMessage);
      print("msg from server inserted");
      messages.add(mMessage);
    }

    for (var seenId in seen_chat_ids) {
      print("seen ids");
      print(seenId);
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
      print(deliveredToThem);
      final idx = messages.indexWhere((m) => m.chatId ==deliveredToThem);
      if (idx != -1 && messages[idx].isSeen != 1) {
        messages[idx] = ChatMessage(
          text: messages[idx].text,
          chatId: messages[idx].chatId,
          isUser: messages[idx].isUser,
          isSeen: 1,
          timestamp: messages[idx].timestamp,
        );
        CartDatabase.updateSeenStatus(messageId: messages[idx].chatId, isSeen: 1);
        print("seen updated");
      }

    }
  }
  @override
  void onClose() {
    _syncTimer?.cancel();
    print("message controller cloased");
    super.onClose();
  }




}

/*{"unseenMessages":[{"chat_id":1,"sender_id":6,"receiver_id":6,"message":"i m ranjan","seen":0,"timestamp":"2025-07-13 09:57:23"}],"mySeenMessageIds":[]}*/
