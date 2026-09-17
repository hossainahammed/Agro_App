import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';

class ChatController extends GetxController {
  // Original chats list for mock database
  final RxList<ChatModel> allChats = <ChatModel>[].obs;
  
  // Filtered chats displayed in UI
  final RxList<ChatModel> chats = <ChatModel>[].obs;

  // Selected chat details
  final Rxn<ChatModel> selectedChat = Rxn<ChatModel>();
  final RxList<MessageModel> activeMessages = <MessageModel>[].obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // Chat message map (stores message history for each chat ID)
  final Map<String, List<MessageModel>> _chatHistoryMap = {};

  @override
  void onInit() {
    super.onInit();
    _loadMockChats();
    _loadMockMessages();
    // Start with all chats
    chats.assignAll(allChats);
  }

  void _loadMockChats() {
    allChats.assignAll([
      ChatModel(
        id: '1',
        name: 'Aisha Musa',
        initials: 'AM',
        avatarColor: const Color(0xFFFFA000), // Orange
        lastMessage: 'Let know what you think 🙏',
        lastMessageTime: '9:20 AM',
        unreadCount: 3,
        isLastMessageMe: false,
        isLastMessageRead: false,
        isOnline: true,
      ),
      ChatModel(
        id: '2',
        name: 'Chukwudi Eze',
        initials: 'CE',
        avatarColor: const Color(0xFF1E88E5), // Blue
        lastMessage: 'Okay, driver will be there. Please have it pack',
        lastMessageTime: '8:45 AM',
        unreadCount: 1,
        isLastMessageMe: false,
        isLastMessageRead: false,
        isOnline: true,
      ),
      ChatModel(
        id: '3',
        name: 'Fatima Bello',
        initials: 'FB',
        avatarColor: const Color(0xFFEC407A), // Pink
        lastMessage: 'Looking forward to it! Talk soon.',
        lastMessageTime: 'Jun 17',
        unreadCount: 0,
        isLastMessageMe: true,
        isLastMessageRead: true,
        isOnline: false,
      ),
      ChatModel(
        id: '4',
        name: 'Emeka Okonkwo',
        initials: 'EO',
        avatarColor: const Color(0xFF26A69A), // Teal
        lastMessage: "Just confirmed — he'll be there by 2 PM.",
        lastMessageTime: 'Jun 16',
        unreadCount: 0,
        isLastMessageMe: false,
        isLastMessageRead: true,
        isOnline: false,
      ),
      ChatModel(
        id: '5',
        name: 'Ngozi Adaeze',
        initials: 'NA',
        avatarColor: const Color(0xFFAB47BC), // Purple
        lastMessage: 'Wonderful! Thank you for the feedback.',
        lastMessageTime: 'Jun 14',
        unreadCount: 0,
        isLastMessageMe: true,
        isLastMessageRead: true,
        isOnline: false,
      ),
      ChatModel(
        id: '6',
        name: 'Yusuf Garba',
        initials: 'YG',
        avatarColor: const Color(0xFF26C6DA), // Cyan
        lastMessage: "Sure! I'll have a fresh batch ready. Jus",
        lastMessageTime: 'Jun 12',
        unreadCount: 0,
        isLastMessageMe: true,
        isLastMessageRead: true,
        isOnline: false,
      ),
    ]);
  }

  void _loadMockMessages() {
    // Aisha Musa's conversation from the screenshot
    _chatHistoryMap['1'] = [
      MessageModel(
        id: 'm1_1',
        text: 'Hello! I just placed an order for 6 crates of tomatoes.',
        time: '9:10 AM',
        isMe: false,
        isRead: true,
        showAvatar: true,
      ),
      MessageModel(
        id: 'm1_2',
        text: "Hi Aisha! Yes, I can see your order. I'll get it ready today.",
        time: '9:13 AM',
        isMe: true,
        isRead: true,
        showAvatar: false,
      ),
      MessageModel(
        id: 'm1_3',
        text: 'Great! Can you make sure the crates are sealed well? Last time one was a bit loose.',
        time: '9:15 AM',
        isMe: false,
        isRead: true,
        showAvatar: true,
      ),
      MessageModel(
        id: 'm1_4',
        text: 'Absolutely, noted! I always double-seal for delivery. No worries.',
        time: '9:16 AM',
        isMe: true,
        isRead: true,
        showAvatar: false,
      ),
      MessageModel(
        id: 'm1_5',
        text: 'Perfect 👍 And is there any chance of a small discount for bulk orders?',
        time: '9:18 AM',
        isMe: false,
        isRead: true,
        showAvatar: false, // Consecutive received message, don't show avatar
      ),
      MessageModel(
        id: 'm1_6',
        text: "I'm planning to order weekly if the quality is consistent.",
        time: '9:19 AM',
        isMe: false,
        isRead: true,
        showAvatar: false, // Consecutive received message, don't show avatar
      ),
    ];

    // Chukwudi Eze's messages
    _chatHistoryMap['2'] = [
      MessageModel(
        id: 'm2_1',
        text: 'Hello, is the order ready for pickup?',
        time: '8:40 AM',
        isMe: false,
        isRead: true,
        showAvatar: true,
      ),
      MessageModel(
        id: 'm2_2',
        text: 'Yes, it is ready. We are waiting for the driver.',
        time: '8:42 AM',
        isMe: true,
        isRead: true,
        showAvatar: false,
      ),
      MessageModel(
        id: 'm2_3',
        text: 'Okay, driver will be there. Please have it pack',
        time: '8:45 AM',
        isMe: false,
        isRead: true,
        showAvatar: true,
      ),
    ];

    // Fatima Bello's messages
    _chatHistoryMap['3'] = [
      MessageModel(
        id: 'm3_1',
        text: 'Hi Samuel, I love the fresh sweet corn I bought last time!',
        time: 'Jun 17, 2:00 PM',
        isMe: false,
        isRead: true,
        showAvatar: true,
      ),
      MessageModel(
        id: 'm3_2',
        text: 'Looking forward to it! Talk soon.',
        time: 'Jun 17, 2:05 PM',
        isMe: true,
        isRead: true,
        showAvatar: false,
      ),
    ];

    // Emeka Okonkwo's messages
    _chatHistoryMap['4'] = [
      MessageModel(
        id: 'm4_1',
        text: 'Can we deliver the cassava flour tomorrow morning?',
        time: 'Jun 16, 1:30 PM',
        isMe: true,
        isRead: true,
        showAvatar: false,
      ),
      MessageModel(
        id: 'm4_2',
        text: "Just confirmed — he'll be there by 2 PM.",
        time: 'Jun 16, 1:45 PM',
        isMe: false,
        isRead: true,
        showAvatar: true,
      ),
    ];

    // Ngozi Adaeze's messages
    _chatHistoryMap['5'] = [
      MessageModel(
        id: 'm5_1',
        text: 'The peppers were very fresh! Thanks a lot.',
        time: 'Jun 14, 10:10 AM',
        isMe: false,
        isRead: true,
        showAvatar: true,
      ),
      MessageModel(
        id: 'm5_2',
        text: 'Wonderful! Thank you for the feedback.',
        time: 'Jun 14, 10:15 AM',
        isMe: true,
        isRead: true,
        showAvatar: false,
      ),
    ];

    // Yusuf Garba's messages
    _chatHistoryMap['6'] = [
      MessageModel(
        id: 'm6_1',
        text: 'I will need 5 bags of cassava flour next week.',
        time: 'Jun 12, 11:30 AM',
        isMe: false,
        isRead: true,
        showAvatar: true,
      ),
      MessageModel(
        id: 'm6_2',
        text: "Sure! I'll have a fresh batch ready. Jus",
        time: 'Jun 12, 11:45 AM',
        isMe: true,
        isRead: true,
        showAvatar: false,
      ),
    ];
  }

  // Set selected chat and load messages
  void selectChat(ChatModel chat) {
    selectedChat.value = chat;
    
    // Clear unread count for this chat
    final int index = allChats.indexWhere((c) => c.id == chat.id);
    if (index != -1) {
      allChats[index] = allChats[index].copyWith(unreadCount: 0);
      _updateFilteredChats();
    }

    // Load messages
    final messages = _chatHistoryMap[chat.id] ?? [];
    activeMessages.assignAll(messages);
  }

  // Filter chats by search query
  void filterChats(String query) {
    searchQuery.value = query;
    _updateFilteredChats();
  }

  void _updateFilteredChats() {
    if (searchQuery.isEmpty) {
      chats.assignAll(allChats);
    } else {
      chats.assignAll(allChats.where((chat) {
        return chat.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            chat.lastMessage.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList());
    }
  }

  // Send a message
  void sendMessage(String text) {
    if (text.trim().isEmpty || selectedChat.value == null) return;

    final chat = selectedChat.value!;
    final now = DateTime.now();
    
    // Format current time as e.g. "9:22 AM"
    final String timeStr = _formatTime(now);

    final newMessage = MessageModel(
      id: 'msg_${now.millisecondsSinceEpoch}',
      text: text,
      time: timeStr,
      isMe: true,
      isRead: false, // will update to read after small delay
      showAvatar: false,
    );

    // Add to active messages
    activeMessages.add(newMessage);

    // Save to history map
    if (!_chatHistoryMap.containsKey(chat.id)) {
      _chatHistoryMap[chat.id] = [];
    }
    _chatHistoryMap[chat.id]!.add(newMessage);

    // Update conversation in the main list
    final int index = allChats.indexWhere((c) => c.id == chat.id);
    if (index != -1) {
      final updatedChat = allChats[index].copyWith(
        lastMessage: text,
        lastMessageTime: timeStr,
        isLastMessageMe: true,
        isLastMessageRead: false,
        unreadCount: 0,
      );
      
      // Move this conversation to the top
      allChats.removeAt(index);
      allChats.insert(0, updatedChat);
      
      // Update selected chat
      selectedChat.value = updatedChat;
      _updateFilteredChats();
    }

    // Simulate delivered status after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      final int msgIndex = activeMessages.indexWhere((m) => m.id == newMessage.id);
      if (msgIndex != -1) {
        activeMessages[msgIndex] = activeMessages[msgIndex].copyWith(isRead: true);
      }

      // Update in stored map
      final chatMessages = _chatHistoryMap[chat.id];
      if (chatMessages != null) {
        final int historyIndex = chatMessages.indexWhere((m) => m.id == newMessage.id);
        if (historyIndex != -1) {
          chatMessages[historyIndex] = chatMessages[historyIndex].copyWith(isRead: true);
        }
      }

      // Update in allChats lastMessageRead status if still matching
      final chatIndex = allChats.indexWhere((c) => c.id == chat.id);
      if (chatIndex != -1 && allChats[chatIndex].lastMessage == text) {
        allChats[chatIndex] = allChats[chatIndex].copyWith(isLastMessageRead: true);
        _updateFilteredChats();
      }
    });
  }

  String _formatTime(DateTime date) {
    int hour = date.hour;
    final int minute = date.minute;
    final String ampm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;
    final String minuteStr = minute < 10 ? '0$minute' : '$minute';
    return '$hour:$minuteStr $ampm';
  }
}
