import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jalebi_shop_flutter/layout/native/mobile/screens/credentials_controller.dart';
import '../../../../../../comman/sys_utilities.dart';
class OutGoingMessage extends StatelessWidget {
  const OutGoingMessage({super.key, required this.message, required this.ts, required this.seen});
  final String message;
  final String ts;
  final int seen;
  @override
  Widget build(BuildContext context) {
    final isDark=isDarkMode(context);
    final credentialController=Get.find<CredentialController>();
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
                ts,
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
            child: Obx(() {
              final pickedFile = credentialController.pickedImage.value;
              return pickedFile != null
                  ? Image.file(
                pickedFile,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/person.png',
                fit: BoxFit.cover,
              );
            }),
          ),
        )
        ,
      ],
    );
  }

}