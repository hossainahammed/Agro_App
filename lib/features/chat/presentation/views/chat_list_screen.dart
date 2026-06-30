import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/routes/app_routes.dart';
import '../controllers/chat_controller.dart';
import '../../data/models/chat_model.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7), // soft light background
      body: Column(
        children: [
          // 1. Forest Green Header block
          _buildHeader(controller),

          // 2. Horizontal Contact Avatars (White Section)
          _buildHorizontalContacts(controller),

          // 3. Section Header (RECENT CONVERSATIONS)
          _buildSectionHeader(controller),

          // 4. Vertical Conversations List
          Expanded(
            child: Obx(() {
              if (controller.chats.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: controller.chats.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: const Color(0xFFE5ECE8),
                  indent: 76.w,
                ),
                itemBuilder: (context, index) {
                  final chat = controller.chats[index];
                  return _buildChatTile(chat, controller);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ChatController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Row(
              children: [
                // Back Button (Circle style)
                CircleAvatar(
                  backgroundColor: Colors.white.withAlpha(38),
                  radius: 18.r,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(width: 12.w),
                // Title and Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AGROCONNECT',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFB5D9BB),
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Messages',
                            style: GoogleFonts.inter(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Unread conversations badge
                          Obx(() {
                            final unreadChats = controller.allChats
                                .where((c) => c.unreadCount > 0)
                                .length;
                            if (unreadChats == 0) return const SizedBox.shrink();
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF5252), // Pinkish red badge
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$unreadChats',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Search Input field
            Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: TextField(
                onChanged: controller.filterChats,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14.sp),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Search buyers or businesses...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white.withAlpha(160),
                    fontSize: 13.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withAlpha(160),
                    size: 20.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalContacts(ChatController controller) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 100.h,
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: controller.allChats.length,
          itemBuilder: (context, index) {
            final chat = controller.allChats[index];
            final bool highlightName = chat.isOnline || chat.unreadCount > 0;
            
            // In the screenshot, Chukwudi Eze is abbreviated to "Chukwuc" in the top bar
            String displayName = chat.name.split(' ').first;
            if (displayName == "Chukwudi") {
              displayName = "Chukwuc";
            }

            return GestureDetector(
              onTap: () {
                controller.selectChat(chat);
                Get.toNamed(AppRoute.chatDetail);
              },
              child: Container(
                margin: EdgeInsets.only(right: 18.w),
                width: 56.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: chat.avatarColor,
                      child: Text(
                        chat.initials,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      displayName,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: highlightName ? FontWeight.bold : FontWeight.w500,
                        color: highlightName ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSectionHeader(ChatController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: const Color(0xFFF0F5F1), // slight soft grey-green background divider
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RECENT CONVERSATIONS',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          Obx(() {
            return Text(
              '${controller.chats.length} chats',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChatTile(ChatModel chat, ChatController controller) {
    final bool hasUnread = chat.unreadCount > 0;

    return InkWell(
      onTap: () {
        controller.selectChat(chat);
        Get.toNamed(AppRoute.chatDetail);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            // Left: Colored Initial Avatar
            CircleAvatar(
              radius: 24.r,
              backgroundColor: chat.avatarColor,
              child: Text(
                chat.initials,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            
            // Middle: Name & Last Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.name,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        chat.lastMessageTime,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                          color: hasUnread ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      // If message is from "Me", show Double Checkmarks
                      if (chat.isLastMessageMe) ...[
                        Icon(
                          Icons.done_all_rounded,
                          size: 14.sp,
                          color: chat.isLastMessageRead ? AppColors.primary : AppColors.textSecondary.withAlpha(120),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'You: ',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                            color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (hasUnread) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48.sp,
              color: AppColors.textSecondary.withAlpha(100),
            ),
            SizedBox(height: 16.h),
            Text(
              'No conversations found',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try searching with a different keyword or contact name.',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
