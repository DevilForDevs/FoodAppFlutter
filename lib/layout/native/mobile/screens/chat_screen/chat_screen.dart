import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'chat_controller.dart'; // make sure the path is correct

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    final isDark=isDarkMode(context);
    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            Get.delete<ChatController>(); // clean up controller
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            leading_icon: Icons.close,
            title: "Ranjan",
            endWidget: IconButton(onPressed: () {
              controller.openDialPad();

            }, icon: const Icon(Icons.call)),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: isDark?Color(0xFF303030):Colors.white,
                  child: Obx(() {
                    return ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      reverse: true,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final msg = controller.messages[controller.messages.length - 1 - index];
                        return VisibilityDetector(
                          onVisibilityChanged: (visibilityInfo) {
                            final visiblePercentage = visibilityInfo.visibleFraction * 100;
                            print("visible item");
                            print(index);
                            if (visiblePercentage >= 95.0) {
                              if(controller.messages[index].isUser){
                                //not applicable
                              }else{
                                if(controller.messages[index].isSeen==2){
                                  //not applicable
                                }else{
                                  controller.visibleChatIds.add(controller.messages[index].chatId);
                                }
                              }
                            }
                          },
                          key: Key('msg-$index'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              msg.isUser
                                  ? OutGoingMessage(message: msg.text,ts:msg.text,seen: msg.isSeen,)
                                  : IncomingMessage(message: msg.text),
                              if (index != 0) const SizedBox(height: 16),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, right: 12, left: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark?Color(0xFF303030):Color(0xFFF0F5FA),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.emoji_emotions_outlined, color: Colors.grey[700]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: controller.inputController,
                          onChanged: (val) => controller.messageText.value = val,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark?Color(0xFF212121):Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Transform.rotate(
                            angle: -0.785398, // -45 degrees
                            child: const Icon(Icons.send, color: Color(0xFFFF7622)),
                          ),
                          onPressed: () {
                            controller.sendMessage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
}

class IncomingMessage extends StatelessWidget {
  const IncomingMessage({
    super.key,
    required this.message,
  });
  final String message;


  @override
  Widget build(BuildContext context) {

    final isDark=isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(top: 20),
          child: ClipOval(
            child: Image.asset(
              "assets/person.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // ← date aligns left
            children: [
              // Date text (now left aligned)
              Text(
                "July 1, 2025",
                style:  TextStyle(fontSize: 12, color: isDark?Colors.white:Color(0xFF1A1817)),
              ),
              const SizedBox(height: 4),

              // Chat bubble
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color:isDark?Color(0xFF212121):Color(0xFFF0F5FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 14, color: isDark?Colors.white:Colors.black),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}


class OutGoingMessage extends StatelessWidget {
  const OutGoingMessage({super.key, required this.message, required this.ts, required this.seen});
  final String message;
  final String ts;
  final int seen;
  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20,right: 10),
          child:  seen==0?Icon(Icons.check,color: Colors.grey,size: 16,):Icon(Icons.done_all, size: 16, color:seen==2?Color(0xFFFF7622):Colors.grey),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // ← date aligns left
            children: [
              // Date text (now left aligned)
              Text(
                "12 july",
                style: TextStyle(fontSize: 12, color: isDark?Colors.white:Color(0xFF1A1817)),
              ),
              const SizedBox(height: 4),

              // Chat bubble
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7622),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Avatar
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(top: 20),
          child: ClipOval(
            child: Image.asset(
              "assets/person.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

}
