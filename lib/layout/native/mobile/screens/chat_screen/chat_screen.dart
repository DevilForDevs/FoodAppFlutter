import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/comman/sys_utilities.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/chat_screen/widgets/incoming_message.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/chat_screen/widgets/out_going_message.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/commans/custom_app_bar.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'chat_controller.dart'; // make sure the path is correct

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    final isDark=isDarkMode(context);
    final credentialController=Get.find<CredentialController>();
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
                                  ? OutGoingMessage(message: msg.text,ts:msg.timestamp,seen: msg.isSeen,)
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
                            if(credentialController.isQrSignIN.value){
                              Fluttertoast.showToast(
                                msg: "Chat feature unavailable, use call ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                            }else{
                              controller.sendMessage();
                            }

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




