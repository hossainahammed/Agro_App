import 'package:flutter/material.dart';

class ChatModel {
  final String id;
  final String name;
  final String initials;
  final Color avatarColor;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isLastMessageMe;
  final bool isLastMessageRead;
  final bool isOnline;

  ChatModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isLastMessageMe,
    required this.isLastMessageRead,
    required this.isOnline,
  });

  ChatModel copyWith({
    String? id,
    String? name,
    String? initials,
    Color? avatarColor,
    String? lastMessage,
    String? lastMessageTime,
    int? unreadCount,
    bool? isLastMessageMe,
    bool? isLastMessageRead,
    bool? isOnline,
  }) {
    return ChatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      avatarColor: avatarColor ?? this.avatarColor,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isLastMessageMe: isLastMessageMe ?? this.isLastMessageMe,
      isLastMessageRead: isLastMessageRead ?? this.isLastMessageRead,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
