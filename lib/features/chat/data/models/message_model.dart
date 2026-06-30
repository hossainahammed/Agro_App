class MessageModel {
  final String id;
  final String text;
  final String time;
  final bool isMe;
  final bool isRead;
  final bool showAvatar;

  MessageModel({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    required this.isRead,
    this.showAvatar = true,
  });

  MessageModel copyWith({
    String? id,
    String? text,
    String? time,
    bool? isMe,
    bool? isRead,
    bool? showAvatar,
  }) {
    return MessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      time: time ?? this.time,
      isMe: isMe ?? this.isMe,
      isRead: isRead ?? this.isRead,
      showAvatar: showAvatar ?? this.showAvatar,
    );
  }
}
