import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../controllers/chat_controller.dart';
import '../../data/models/message_model.dart';

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7), // soft light background
      appBar: _buildAppBar(controller),
      body: Column(
        children: [
          // Date Group Header
          _buildDateDivider('Today'),

          // Messages List
          Expanded(
            child: Obx(() {
              final messages = controller.activeMessages.reversed.toList();
              
              if (messages.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet. Say hello!',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final chat = controller.selectedChat.value;
                  
                  if (message.isMe) {
                    return _buildSentBubble(message);
                  } else {
                    return _buildReceivedBubble(message, chat?.initials ?? '', chat?.avatarColor ?? AppColors.primary);
                  }
                },
              );
            }),
          ),

          // Bottom Input Field
          _buildBottomInput(controller, textController),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ChatController controller) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      toolbarHeight: 70.h,
      leadingWidth: 52.w,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Center(
          child: CircleAvatar(
            backgroundColor: Colors.white.withAlpha(38),
            radius: 18.r,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
      title: Obx(() {
        final chat = controller.selectedChat.value;
        if (chat == null) return const SizedBox.shrink();
        
        return Row(
          children: [
            // Contact Circle Avatar
            CircleAvatar(
              radius: 18.r,
              backgroundColor: chat.avatarColor,
              child: Text(
                chat.initials,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Contact Name & Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chat.name,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    chat.isOnline ? 'Online now' : 'Offline',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: chat.isOnline ? const Color(0xFFB5D9BB) : AppColors.white.withAlpha(160),
                      fontWeight: chat.isOnline ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDateDivider(String date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Color(0xFFE0ECE8),
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              date,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Color(0xFFE0ECE8),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedBubble(MessageModel message, String initials, Color avatarColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Avatar (or placeholder spacing if consecutive)
          if (message.showAvatar)
            CircleAvatar(
              radius: 16.r,
              backgroundColor: avatarColor,
              child: Text(
                initials,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            SizedBox(width: 32.w),
          
          SizedBox(width: 8.w),

          // Message Bubble + Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(message.showAvatar ? 4.r : 16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(
                    message.time,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentBubble(MessageModel message) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.7),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(4.r),
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(20),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14.sp,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.done_all_rounded,
                  size: 13.sp,
                  color: message.isRead ? AppColors.primary : AppColors.textSecondary.withAlpha(120),
                ),
                SizedBox(width: 4.w),
                Text(
                  message.time,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInput(ChatController controller, TextEditingController textController) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Text Input field
            Expanded(
              child: Container(
                height: 46.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5F1), // very light green/grey input field
                  borderRadius: BorderRadius.circular(23.r),
                ),
                child: TextField(
                  controller: textController,
                  style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.textSecondary.withAlpha(120),
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                  ),
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      controller.sendMessage(text);
                      textController.clear();
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 10.w),
            // Send Button
            GestureDetector(
              onTap: () {
                final String text = textController.text;
                if (text.trim().isNotEmpty) {
                  controller.sendMessage(text);
                  textController.clear();
                }
              },
              child: Container(
                width: 46.h,
                height: 46.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F3EA), // Very soft green circle background
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.send_rounded,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
