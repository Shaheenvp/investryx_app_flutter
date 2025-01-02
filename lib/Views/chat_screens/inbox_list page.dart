// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import '../../services/chatUserCheck.dart';
// import '../../services/inbox service.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'chat screen.dart';
//
// class InboxListScreen extends StatefulWidget {
//   const InboxListScreen({Key? key}) : super(key: key);
//
//   @override
//   _InboxListScreenState createState() => _InboxListScreenState();
// }
//
// class _InboxListScreenState extends State<InboxListScreen> with SingleTickerProviderStateMixin {
//   final FlutterSecureStorage _storage = FlutterSecureStorage();
//   final ScrollController _scrollController = ScrollController();
//   final StreamController<List<InboxItems>> _inboxController = StreamController<List<InboxItems>>.broadcast();
//   final StreamController<bool> _connectionController = StreamController<bool>.broadcast();
//   List<InboxItems>? _inboxData;
//   late WebSocketChannel channel;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//
//   int? chatUserId;
//   String? token;
//   int? _selectedIndex;
//   bool _isLoading = true;
//   bool _isWebSocketConnected = false;
//   Timer? _reconnectTimer;
//   Timer? _pingTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeWebSocketConnection();
//     _fetchInboxData();
//   }
//
//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }
//
//   Future<void> _fetchInboxData() async {
//     try {
//       final userId = await ChatUserCheck.fetchChatUserData();
//       final inboxData = await Inbox.fetchInboxData();
//
//       if (mounted) {
//         setState(() {
//           chatUserId = userId;
//           _inboxData = inboxData ?? [];
//           _isLoading = false;
//         });
//
//         // Add data to stream
//         if (inboxData != null) {
//           _inboxController.add(inboxData);
//         } else {
//           _inboxController.add([]);
//         }
//         log('Fetched inbox data: ${inboxData?.length ?? 0} items');
//       }
//     } catch (e) {
//       log('Error fetching inbox data: $e');
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _inboxData = [];
//         });
//         _inboxController.add([]);
//       }
//     }
//   }
//
//   void _handleWebSocketMessage(dynamic message) {
//     if (!mounted) return;
//
//     try {
//       log('Processing WebSocket room: $message');
//       final messageData = message is String ? jsonDecode(message) : message as Map<String, dynamic>;
//
//       if (messageData['type'] == 'pong') return;
//
//       final roomData = messageData['room'] as Map<String, dynamic>?;
//       if (roomData == null) return;
//       print('first name is = ${roomData['first_name']}');
//
//       // Create formatted data structure
//       Map<String, dynamic> formattedData = {
//         'id': roomData['id'],
//         'first_person': {
//           'id': roomData['first_person'],
//           'first_name': roomData['first_name'],
//           'image': roomData['first_image'],
//           'username': null
//         },
//         'second_person': {
//           'id': roomData['second_person'],
//           'first_name': roomData['second_name'],
//           'image': roomData['second_image'],
//           'username': null
//         },
//         'last_msg': roomData['last_msg'],
//         'updated': roomData['updated']
//       };
//
//       final newItem = InboxItems.fromJson(formattedData);
//       log('Created new item: ${newItem.id} - ${newItem.message}');
//
//       setState(() {
//         _inboxData ??= [];
//
//         // Find existing conversation
//         final existingIndex = _inboxData!.indexWhere((item) =>
//         item.id == newItem.id ||
//             (item.first_id == newItem.first_id && item.second_id == newItem.second_id) ||
//             (item.first_id == newItem.second_id && item.second_id == newItem.first_id)
//         );
//
//         if (existingIndex != -1) {
//           _inboxData!.removeAt(existingIndex);
//         }
//         _inboxData!.insert(0, newItem);
//
//         // Update stream with new data
//         _inboxController.add(_inboxData!);
//       });
//
//     } catch (e, stackTrace) {
//       log('Error in _handleWebSocketMessage: $e');
//       log('Stack trace: $stackTrace');
//     }
//   }
//
//   Future<void> _initializeWebSocketConnection() async {
//     try {
//       token = await _storage.read(key: 'token');
//       if (token == null) {
//         if (mounted) _showSnackBar('Token not found. Please login again.');
//         return;
//       }
//
//       channel = WebSocketChannel.connect(
//         Uri.parse('wss://r5v6mkbr-8001.inc1.devtunnels.ms/rooms?token=$token'),
//       );
//
//       channel.stream.listen(
//         _handleWebSocketMessage,
//         onError: (error) {
//           log('WebSocket error: $error');
//           _handleWebSocketError();
//         },
//         onDone: () {
//           log('WebSocket connection closed');
//           _handleWebSocketClosed();
//         },
//         cancelOnError: false,
//       );
//
//       setState(() => _isWebSocketConnected = true);
//       _connectionController.add(true);
//       _startPingTimer();
//
//     } catch (e) {
//       log('Connection error: $e');
//       _handleWebSocketError();
//     }
//   }
//
//   void _startPingTimer() {
//     _pingTimer?.cancel();
//     _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
//       if (!mounted || !_isWebSocketConnected) {
//         timer.cancel();
//         return;
//       }
//
//       try {
//         channel.sink.add(jsonEncode({'type': 'ping'}));
//       } catch (e) {
//         timer.cancel();
//         _handleWebSocketError();
//       }
//     });
//   }
//
//   void _handleWebSocketError() {
//     if (!mounted) return;
//     setState(() => _isWebSocketConnected = false);
//     _connectionController.add(false);
//     _scheduleReconnect();
//   }
//
//   void _handleWebSocketClosed() {
//     if (!mounted) return;
//     setState(() => _isWebSocketConnected = false);
//     _connectionController.add(false);
//     _scheduleReconnect();
//   }
//
//   void _scheduleReconnect() {
//     _reconnectTimer?.cancel();
//     _reconnectTimer = Timer(const Duration(seconds: 3), () {
//       if (mounted && !_isWebSocketConnected) {
//         _initializeWebSocketConnection();
//       }
//     });
//   }
//
//   void _showSnackBar(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       behavior: SnackBarBehavior.floating,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Conversations',
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             StreamBuilder<bool>(
//               stream: _connectionController.stream,
//               initialData: true,
//               builder: (context, snapshot) {
//                 return Text(
//                   snapshot.data! ? 'Connected' : 'Connecting...',
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: snapshot.data! ? Colors.green : Colors.orange,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.black87),
//             onPressed: () {
//               // Implement search functionality
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           if (_isLoading)
//             _buildShimmerList()
//           else
//             StreamBuilder<List<InboxItems>>(
//               stream: _inboxController.stream,
//               initialData: _inboxData ?? const [],
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return _buildErrorState();
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return _buildEmptyState();
//                 }
//
//                 return _buildInboxList(snapshot.data!);
//               },
//             ),
//           _buildConnectionStatus(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildConversationTile(InboxItems conversation) {
//     final bool isFirstPerson = chatUserId == (conversation.first_id != null ? int.parse(conversation.first_id!) : null);
//     final String displayName = isFirstPerson ? conversation.second_name : conversation.first_name;
//     final String displayImage = isFirstPerson ? conversation.second_image ?? '' : conversation.first_image ?? '';
//
//     return Padding(
//       padding: EdgeInsets.all(12.r),
//       child: Row(
//         children: [
//           Hero(
//             tag: 'avatar_${conversation.id}',
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: CircleAvatar(
//                 radius: 28.r,
//                 backgroundColor: Colors.grey[200],
//                 backgroundImage: displayImage.isNotEmpty ? NetworkImage(displayImage) : null,
//                 child: displayImage.isEmpty
//                     ? Icon(Icons.person, color: Colors.grey, size: 32.r)
//                     : null,
//               ),
//             ),
//           ),
//           SizedBox(width: 16.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         displayName,
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Text(
//                       _formatDateTime(conversation.time),
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 6.h),
//                 Text(
//                   conversation.message ?? '',
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colors.grey[600],
//                     height: 1.2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildInboxList(List<InboxItems> inboxData) {
//     return ListView.builder(
//       controller: _scrollController,
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       itemCount: inboxData.length,
//       itemBuilder: (context, index) {
//         final conversation = inboxData[index];
//         final isSelected = _selectedIndex == index;
//
//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeInOut,
//           margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               if (isSelected)
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 )
//             ],
//           ),
//           child: ScaleTransition(
//             scale: isSelected ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12.r),
//                 onTapDown: (_) {
//                   setState(() => _selectedIndex = index);
//                   _animationController.forward();
//                 },
//                 onTapUp: (_) {
//                   _animationController.reverse();
//                   Future.delayed(const Duration(milliseconds: 150), () {
//                     _navigateToChat(conversation);
//                   });
//                 },
//                 onTapCancel: () {
//                   setState(() => _selectedIndex = null);
//                   _animationController.reverse();
//                 },
//                 child: _buildConversationTile(conversation),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Lottie.asset(
//             'assets/nodata.json',
//             height: 160.h,
//             width: 160.w,
//             fit: BoxFit.contain,
//           ),
//           SizedBox(height: 24.h),
//           Text(
//             "No conversations yet",
//             style: TextStyle(
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 12.h),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 32.w),
//             child: Text(
//               "Start connecting with others and your conversations will appear here",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey[600],
//                 height: 1.4,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 64.r,
//             color: Colors.red[300],
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             'Something went wrong',
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           TextButton(
//             onPressed: _fetchInboxData,
//             child: const Text('Try Again'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildShimmerList() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         itemCount: 8,
//         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//         itemBuilder: (context, index) => Container(
//           margin: EdgeInsets.symmetric(vertical: 4.h),
//           padding: EdgeInsets.all(12.r),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 28.r,
//                 backgroundColor: Colors.white,
//               ),
//               SizedBox(width: 16.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           width: 120.w,
//                           height: 16.h,
//                           color: Colors.white,
//                         ),
//                         Container(
//                           width: 40.w,
//                           height: 12.h,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8.h),
//                     Container(
//                       width: double.infinity,
//                       height: 14.h,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildConnectionStatus() {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       child: StreamBuilder<bool>(
//         stream: _connectionController.stream,
//         initialData: true,
//         builder: (context, snapshot) {
//           return AnimatedSlide(
//             duration: const Duration(milliseconds: 300),
//             offset: Offset(0, snapshot.data! ? -1 : 0),
//             child: Container(
//               color: Colors.red[400],
//               padding: EdgeInsets.symmetric(vertical: 6.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 12.r,
//                     height: 12.r,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Text(
//                     'Reconnecting...',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _navigateToChat(InboxItems conversation) {
//     final bool isFirstPerson = chatUserId == (conversation.first_id != null ? int.parse(conversation.first_id!) : null);
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         transitionDuration: const Duration(milliseconds: 300),
//         pageBuilder: (context, animation, secondaryAnimation) =>
//             FadeScaleTransition(
//               animation: animation,
//               child: ChatScreen(
//                 roomId: conversation.id,
//                 name: isFirstPerson ? conversation.second_name : conversation.first_name,
//                 imageUrl: isFirstPerson ? conversation.second_image ?? '' : conversation.first_image ?? '',
//                 chatUserId: chatUserId,
//                 number: conversation.first_phone,
//               ),
//             ),
//       ),
//     ).then((_) {
//       setState(() => _selectedIndex = null);
//     });
//   }
//   String _formatDateTime(String dateTimeStr) {
//     try {
//       final dateTime = DateTime.parse(dateTimeStr);
//       return timeago.format(dateTime, allowFromNow: true);
//     } catch (e) {
//       log('Error formatting date: $e');
//       return dateTimeStr;
//     }
//   }
//
//   void _cleanupWebSocket() {
//     try {
//       if (_isWebSocketConnected) {
//         channel.sink.close();
//       }
//     } catch (e) {
//       log('Error closing WebSocket: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _reconnectTimer?.cancel();
//     _pingTimer?.cancel();
//     _scrollController.dispose();
//     _inboxController.close();
//     _connectionController.close();
//     _cleanupWebSocket();
//     super.dispose();
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:project_emergio/Views/chat_screens/websocket%20integration.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/chatUserCheck.dart';
import '../../services/inbox service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'chat screen.dart';

class InboxListScreen extends StatefulWidget {
  const InboxListScreen({Key? key}) : super(key: key);

  @override
  _InboxListScreenState createState() => _InboxListScreenState();
}

class _InboxListScreenState extends State<InboxListScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final StreamController<List<InboxItems>> _inboxController = StreamController<List<InboxItems>>.broadcast();
  List<InboxItems>? _inboxData;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late StreamSubscription _messageSubscription;
  late StreamSubscription _connectionSubscription;
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<InboxItems> _filteredInboxData = [];

  int? chatUserId;
  int? _selectedIndex;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupWebSocketListeners();
    _fetchInboxData();
  }

  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredInboxData = _inboxData ?? [];
      });
      return;
    }

    setState(() {
      _filteredInboxData = _inboxData?.where((item) {
        final bool isFirstPerson = chatUserId == (item.first_id != null ? int.parse(item.first_id!) : null);
        final String displayName = isFirstPerson ? item.second_name : item.first_name;
        final String message = item.message?.toLowerCase() ?? '';

        return displayName.toLowerCase().contains(query.toLowerCase()) ||
            message.contains(query.toLowerCase());
      }).toList() ?? [];
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _setupWebSocketListeners() {
    _messageSubscription = WebSocketManager().messageStream.listen(_handleWebSocketMessage);
    _connectionSubscription = WebSocketManager().connectionStream.listen((connected) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _fetchInboxData() async {
    try {
      final userId = await ChatUserCheck.fetchChatUserData();
      final inboxData = await Inbox.fetchInboxData();

      if (mounted) {
        setState(() {
          chatUserId = userId;
          _inboxData = inboxData ?? [];
          _isLoading = false;
        });

        if (inboxData != null) {
          _inboxController.add(inboxData);
        } else {
          _inboxController.add([]);
        }
        log('Fetched inbox data: ${inboxData?.length ?? 0} items');
      }
    } catch (e) {
      log('Error fetching inbox data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _inboxData = [];
        });
        _inboxController.add([]);
      }
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    if (!mounted) return;

    try {
      log('Processing WebSocket room: $message');
      final messageData = message is String ? jsonDecode(message) : message as Map<String, dynamic>;

      if (messageData['type'] == 'pong') return;
      if (messageData['type'] != 'room_update') return;  // Only handle room_update messages

      final roomData = messageData['room'] as Map<String, dynamic>?;
      if (roomData == null) return;

      // Determine if current user is first_person
      final isFirstPerson = chatUserId == int.parse(roomData['first_person'].toString());

      // Calculate unread messages for first and second person
      final totalUnread = roomData['total_unread'] ?? 0;
      final unreadMessages = roomData['unread_messages'] ?? 0;

      // Assign unread counts based on user position
      final unreadFirst = isFirstPerson ? unreadMessages : totalUnread - unreadMessages;
      final unreadSecond = isFirstPerson ? totalUnread - unreadMessages : unreadMessages;

      Map<String, dynamic> formattedData = {
        'id': roomData['id'],
        'first_person': {
          'id': roomData['first_person'],
          'first_name': roomData['first_name'],
          'image': roomData['first_image'],
          'username': null,
          'is_active': roomData['active'] ?? false,
          'inactive_from': roomData['last_seen'] ?? 'N/A'
        },
        'second_person': {
          'id': roomData['second_person'],
          'first_name': roomData['second_name'],
          'image': roomData['second_image'],
          'username': null,
          'is_active': roomData['active'] ?? false,
          'inactive_from': roomData['last_seen'] ?? 'N/A'
        },
        'last_msg': roomData['last_msg'],
        'updated': roomData['updated'],
        'unread_messages_first': unreadFirst,
        'unread_messages_second': unreadSecond
      };

      final newItem = InboxItems.fromJson(formattedData);
      log('Created new item: ${newItem.id} - ${newItem.message} - Unread First: ${newItem.unread_messages_first}, Unread Second: ${newItem.unread_messages_second}');

      setState(() {
        _inboxData ??= [];

        final existingIndex = _inboxData!.indexWhere((item) =>
        item.id == newItem.id ||
            (item.first_id == newItem.first_id && item.second_id == newItem.second_id) ||
            (item.first_id == newItem.second_id && item.second_id == newItem.first_id)
        );

        if (existingIndex != -1) {
          _inboxData!.removeAt(existingIndex);
        }

        _inboxData!.insert(0, newItem);
        _inboxController.add(_inboxData!);
      });

    } catch (e, stackTrace) {
      log('Error in _handleWebSocketMessage: $e');
      log('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          if (_isLoading)
            _buildShimmerList()
          else
            StreamBuilder<List<InboxItems>>(
              stream: _inboxController.stream,
              initialData: _inboxData ?? const [],
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildErrorState();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final displayData = _isSearching ? _filteredInboxData : snapshot.data!;

                if (_isSearching && displayData.isEmpty) {
                  return _buildNoSearchResults();
                }

                return _buildInboxList(displayData);
              },
            ),
          _buildConnectionStatus(),
        ],
      ),
    );
  }

// Add this method to build the search AppBar
  PreferredSizeWidget _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _filteredInboxData = _inboxData ?? [];
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search conversations...',
            hintStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[400],
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black87,
          ),
          onChanged: _handleSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.black87),
              onPressed: () {
                _searchController.clear();
                _handleSearch('');
              },
            ),
        ],
      );
    }

    return AppBar(
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conversations',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          StreamBuilder<bool>(
            stream: WebSocketManager().connectionStream,
            initialData: WebSocketManager().isConnected,
            builder: (context, snapshot) {
              return Text(
                snapshot.data! ? 'Connected' : 'Connecting...',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: snapshot.data! ? Colors.green : Colors.orange,
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black87),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ],
    );
  }


    Widget _buildConversationTile(InboxItems conversation) {
      final bool isFirstPerson = chatUserId == (conversation.first_id != null ? int.parse(conversation.first_id!) : null);
      final String displayName = isFirstPerson ? conversation.second_name : conversation.first_name;
      final String displayImage = isFirstPerson ? conversation.second_image ?? '' : conversation.first_image ?? '';
      final int unreadCount = isFirstPerson ? conversation.unread_messages_first : conversation.unread_messages_second;
      final bool hasUnread = unreadCount > 0;

      // App theme colors
      final Color primaryYellow = const Color(0xFFFFB800); // Main yellow color
      final Color secondaryYellow = const Color(0xFFFFD166); // Lighter yellow
      final Color unreadBgColor = const Color(0xFFFFF8E7); // Very light yellow background
      final Color textColor = const Color(0xFF2D2D2D); // Dark text color

      return Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: hasUnread ? unreadBgColor : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'avatar_${conversation.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: hasUnread
                          ? Border.all(color: primaryYellow, width: 2)
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 28.r,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: displayImage.isNotEmpty ? NetworkImage(displayImage) : null,
                      child: displayImage.isEmpty
                          ? Icon(Icons.person, color: Colors.grey[300], size: 32.r)
                          : null,
                    ),
                  ),
                ),
                if (hasUnread)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: primaryYellow,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDateTime(conversation.time),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: hasUnread ? primaryYellow : Colors.grey[500],
                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.message ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: hasUnread ? textColor : Colors.grey[600],
                            fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: primaryYellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

  // Update the list item builder to match the theme
  Widget _buildListItem(InboxItems conversation, int index) {
    final bool isSelected = _selectedIndex == index;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTapDown: (_) {
            setState(() => _selectedIndex = index);
            _animationController.forward();
          },
          onTapUp: (_) {
            _animationController.reverse();
            Future.delayed(const Duration(milliseconds: 150), () {
              _navigateToChat(conversation);
            });
          },
          onTapCancel: () {
            setState(() => _selectedIndex = null);
            _animationController.reverse();
          },
          child: _buildConversationTile(conversation),
        ),
      ),
    );
  }

  Widget _buildInboxList(List<InboxItems> inboxData) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      itemCount: inboxData.length,
      itemBuilder: (context, index) => _buildListItem(inboxData[index], index),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/nodata.json',
            height: 160.h,
            width: 160.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 24.h),
          Text(
            "No conversations yet",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              "Start connecting with others and your conversations will appear here",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.r,
            color: Colors.red[300],
          ),
          SizedBox(height: 16.h),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: _fetchInboxData,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120.w,
                      height: 14.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 200.w,
                      height: 12.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Container(
                width: 40.w,
                height: 12.h,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: StreamBuilder<bool>(
        stream: WebSocketManager().connectionStream,
    initialData: WebSocketManager().isConnected,
    builder: (context, snapshot) {
    return AnimatedSlide(
    duration: const Duration(milliseconds: 300),
    offset: Offset(0, snapshot.data! ? -1 : 0),
    child: Container(
    color: Colors.red[400],
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 12.r,
          height: 12.r,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'Reconnecting...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    ),
    );
    },
        ),
    );
  }

  void _navigateToChat(InboxItems conversation) {
    final bool isFirstPerson = chatUserId == (conversation.first_id != null ? int.parse(conversation.first_id!) : null);
    final bool isActive = isFirstPerson
        ? conversation.second_is_active
        : conversation.first_is_active;

    final String inactiveFrom = isFirstPerson
        ? conversation.second_inactive_from
        : conversation.first_inactive_from;

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FadeScaleTransition(
              animation: animation,
              child: ChatScreen(
                roomId: conversation.id,
                name: isFirstPerson ? conversation.second_name : conversation.first_name,
                imageUrl: isFirstPerson ? conversation.second_image ?? '' : conversation.first_image ?? '',
                chatUserId: chatUserId,
                number: conversation.first_phone,
                isActive: isActive,
                lastActive: inactiveFrom,
              ),
            ),
      ),
    ).then((_) {
      // Refresh inbox items when returning from chat screen
      setState(() => _selectedIndex = null);
      _fetchInboxData(); // Refetch inbox data

      // Show loading state while fetching
      setState(() {
        _isLoading = true;
      });
    });
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No matches found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              'Try different keywords or check for typos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              _handleSearch('');
            },
            icon: const Icon(Icons.clear),
            label: const Text('Clear Search'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFFB800),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return timeago.format(dateTime, allowFromNow: true);
    } catch (e) {
      log('Error formatting date: $e');
      return dateTimeStr;
    }
  }


  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    _inboxController.close();
    _messageSubscription.cancel();
    _connectionSubscription.cancel();
    super.dispose();
  }
}