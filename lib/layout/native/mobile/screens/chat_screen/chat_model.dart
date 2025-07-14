class MessageModel {
  final int chatId;
  final int senderId;
  final int receiverId;
  final String message;
  final bool seen;
  final DateTime timestamp;

  MessageModel({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.seen,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      seen: json['seen'] == 1,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
