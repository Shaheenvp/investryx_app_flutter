import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:project_emergio/Views/chat_screens/voice_handler.dart';
import 'package:project_emergio/Views/detail%20page/business%20deatil%20page.dart';
import 'package:project_emergio/Views/detail%20page/franchise%20detail%20page.dart';
import 'package:project_emergio/Views/detail%20page/invester%20detail%20page.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../models/all profile model.dart';
import '../../services/get_post_service.dart';
import 'attachment_handler.dart';

class ChatColors {
  static const Color primary = Color(0xFFFFD740);
  static const Color primaryLight = Color(0xFFFFE57F);
  static const Color primaryDark = Color(0xFFFFC400);
  static const Color background = Color(0xFFFAFAFA);
  static const Color messageBubble = Color(0xFFF5F5F5);
  static const Color text = Color(0xFF424242);
  static const Color subtleText = Color(0xFF757575);
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String? imageUrl;
  final String roomId;
  final String? phoneNumber;
  final VoidCallback onBackPress;
  final Function(String) onPhonePress;
  final bool isActive;
  final String lastActive;
  final String? postId;
  final String? entityType;

  const ChatAppBar({
    Key? key,
    required this.name,
    this.imageUrl,
    required this.roomId,
    this.phoneNumber,
    required this.onBackPress,
    required this.onPhonePress,
    required this.isActive,
    required this.lastActive,
    this.postId,
    this.entityType,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _handleMenuSelect(String value, BuildContext context) async {
    if (value == 'viewPost' && postId != null) {
      final response = await GetPostService.getPost(id: postId!);

      if (response['status'] == true) {
        if (response['data'] != null) {
          _navigateToDetailPage(context, response['entity_type'], response['data']);
        }
      }
    }
  }

  void _navigateToDetailPage(BuildContext context, String? type, Map<String, dynamic> data) {
    if (type == null || type.isEmpty) return;

    switch (type.toLowerCase()) {
      case "business":
        final businessData = BusinessInvestorExplr.fromJson(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailPage(
              id: postId,
              buisines: businessData,
              showEditOption: false,
            ),
          ),
        );
        break;

      case "franchise":
        final franchiseData = FranchiseExplr.fromJson(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FranchiseDetailPage(
              id: postId,
              franchise: franchiseData,
              showEditOption: false,
            ),
          ),
        );
        break;

      case "investor":
        final investorData = BusinessInvestorExplr.fromJson(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvestorDetailPage(
              id: postId,
              investor: investorData,
            ),
          ),
        );
        break;
    }
  }

  String _formatLastActive(String lastActive) {
    try {
      final DateTime lastActiveTime = DateTime.parse(lastActive);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(lastActiveTime);

      if (difference.inMinutes < 1) {
        return 'just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM d, h:mm a').format(lastActiveTime);
      }
    } catch (e) {
      return 'unavailable';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rest of the build method remains the same
    return AppBar(
      backgroundColor: ChatColors.primary,
      elevation: 0,
      leadingWidth: 40,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ChatColors.text, size: 20),
        onPressed: onBackPress,
      ),
      title: Row(
        children: [
          Hero(
            tag: 'avatar_$roomId',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                    ? NetworkImage(imageUrl!)
                    : const AssetImage('assets/profile_picture.jpg') as ImageProvider,
                radius: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: ChatColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green[400] : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? 'Online' : 'Last seen ${_formatLastActive(lastActive)}',
                      style: TextStyle(
                        color: ChatColors.subtleText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call, color: ChatColors.text),
          onPressed: () => phoneNumber != null ? onPhonePress(phoneNumber!) : null,
        ),
        if (postId != null)
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: ChatColors.text),
            onSelected: (value) => _handleMenuSelect(value, context),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'viewPost',
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 20),
                    SizedBox(width: 8),
                    Text('View Post'),
                  ],
                ),
              ),
            ],
          )
        else
          IconButton(
            icon: Icon(Icons.more_vert, color: ChatColors.text),
            onPressed: () {},
          ),
      ],
    );
  }
}

class ChatDateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            'Today',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessagesList extends StatelessWidget {
  final List<Map<String, String>> messages;
  final ScrollController scrollController;
  final int? chatUserId;
  final Function(String) onPlayVoiceMessage;
  final String? currentlyPlayingPath;

  const ChatMessagesList({
    Key? key,
    required this.messages,
    required this.scrollController,
    required this.chatUserId,
    required this.onPlayVoiceMessage,
    this.currentlyPlayingPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView.builder(
        controller: scrollController,
        reverse: true,
        padding: EdgeInsets.only(top: 20, bottom: 10),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          bool isSentMessage = chatUserId.toString() ==
              (message['sendedBy'] is String
                  ? message['sendedBy']
                  : message['sendedBy'].toString());

          // Handle different message types
          switch (message['messageType']) {
            case 'voice':
              final duration = message['duration'] != null
                  ? Duration(seconds: int.parse(message['duration']!))
                  : null;
              return VoiceMessageBubble(
                isFromUser: isSentMessage,
                time: message['time'] ?? '',
                duration: duration ?? Duration.zero,
                onPlayPressed: () => onPlayVoiceMessage(message['audio'] ?? ''),
                isPlaying: message['audio'] == currentlyPlayingPath,
                audioPath: message['audio'],
              );

            case 'attachment':
              return AttachmentBubble(
                attachment: jsonDecode(message['attachment'] ?? '{}'),
                isFromUser: isSentMessage,
                time: message['time'] ?? '',
              );

            default: // Text message
              return MessageBubble(
                isFromUser: isSentMessage,
                message: message['message'] ?? 'No message',
                time: message['time'] ?? '',
              );
          }
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isFromUser;
  final String message;
  final String time;
  final bool isVoiceMessage;
  final VoidCallback? onPlayVoiceMessage;
  final bool isPlaying;
  final Duration? duration;
  final String? audioPath;

  const MessageBubble({
    Key? key,
    required this.isFromUser,
    required this.message,
    required this.time,
    this.isVoiceMessage = false,
    this.onPlayVoiceMessage,
    this.isPlaying = false,
    this.duration,
    this.audioPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isVoiceMessage) {
      return VoiceMessageBubble(
        isFromUser: isFromUser,
        time: time,
        duration: duration ?? Duration.zero,
        onPlayPressed: onPlayVoiceMessage ?? () {},
        isPlaying: isPlaying,
      );
    }

    // Regular text message
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color:
                isFromUser ? ChatColors.primaryLight : ChatColors.messageBubble,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(isFromUser ? 20 : 0),
              bottomRight: Radius.circular(isFromUser ? 0 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: ChatColors.text,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _formatDateTime(time),
                style: TextStyle(
                  color: ChatColors.subtleText,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr).toLocal();
    return DateFormat('hh:mm a').format(dateTime);
  }
}

class ChatUtils {
  static Future<void> makePhoneCall(
      BuildContext context, String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number not available'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await launcher.canLaunchUrl(launchUri)) {
        await launcher.launchUrl(launchUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch phone dialer'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class ChatShimmerEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            bool isSentMessage = index % 2 == 0;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              child: Align(
                alignment: isSentMessage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: isSentMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150.0,
                        height: 12.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        width: 100.0,
                        height: 12.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class ChatErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[300],
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'Failed to load messages',
            style: TextStyle(
              color: Colors.red[300],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // Add refresh functionality if needed
            },
            child: Text(
              'Tap to retry',
              style: TextStyle(
                color: Color(0xffFFCC00),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


