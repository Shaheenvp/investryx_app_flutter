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

class _InboxListScreenState extends State<InboxListScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  final ScrollController _scrollController = ScrollController();
  final StreamController<List<InboxItems>> _inboxController =
  StreamController<List<InboxItems>>.broadcast();
  final TextEditingController _searchController = TextEditingController();
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();


  List<InboxItems>? _inboxData;
  List<InboxItems> _filteredInboxData = [];
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late StreamSubscription _messageSubscription;
  late StreamSubscription _connectionSubscription;
  Timer? _debounceTimer;

  int? chatUserId;
  int? _selectedIndex;
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _initializeAnimations();
    _setupWebSocketListeners();
    _fetchInboxData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    _refreshInboxData();
  }

  Future<void> _refreshInboxData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchInboxData();
  }

  void _handleSearch(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _isSearching = query.isNotEmpty;
        if (query.isEmpty) {
          _filteredInboxData = _inboxData ?? [];
          return;
        }

        _filteredInboxData = _inboxData?.where((item) {
          final bool isFirstPerson = chatUserId ==
              (item.first_id != null ? int.parse(item.first_id!) : null);

          final String displayName = isFirstPerson
              ? (item.second_name ?? '').toLowerCase()
              : (item.first_name ?? '').toLowerCase();

          final String message = (item.message ?? '').toLowerCase();
          final String postTitle = (item.post?.title ?? '').toLowerCase();
          final String searchLower = query.toLowerCase();

          return displayName.contains(searchLower) ||
              message.contains(searchLower) ||
              postTitle.contains(searchLower);
        }).toList() ?? [];
      });
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
    _messageSubscription =
        WebSocketManager().messageStream.listen(_handleWebSocketMessage);
    _connectionSubscription =
        WebSocketManager().connectionStream.listen((connected) {
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
          _filteredInboxData = _inboxData ?? [];
          _isLoading = false;
        });

        if (inboxData != null) {
          _inboxController.add(inboxData);
        } else {
          _inboxController.add([]);
        }
      }
    } catch (e) {
      log('Error fetching inbox data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _inboxData = [];
          _filteredInboxData = [];
        });
        _inboxController.add([]);
      }
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    if (!mounted) return;

    try {
      final messageData = message is String
          ? jsonDecode(message)
          : message as Map<String, dynamic>;

      if (messageData['type'] == 'pong') return;
      if (messageData['type'] != 'room_update') return;

      final roomData = messageData['room'] as Map<String, dynamic>?;
      if (roomData == null) return;

      final isFirstPerson =
          chatUserId == int.parse(roomData['first_person'].toString());

      final totalUnread = roomData['total_unread'] ?? 0;
      final unreadMessages = roomData['unread_messages'] ?? 0;

      final unreadFirst =
      isFirstPerson ? unreadMessages : totalUnread - unreadMessages;
      final unreadSecond =
      isFirstPerson ? totalUnread - unreadMessages : unreadMessages;

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

      setState(() {
        _inboxData ??= [];

        final existingIndex = _inboxData!.indexWhere((item) =>
        item.id == newItem.id ||
            (item.first_id == newItem.first_id &&
                item.second_id == newItem.second_id) ||
            (item.first_id == newItem.second_id &&
                item.second_id == newItem.first_id));

        if (existingIndex != -1) {
          _inboxData!.removeAt(existingIndex);
        }

        _inboxData!.insert(0, newItem);
        _handleSearch(_searchController.text); // Refresh search results
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
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(),
                SizedBox(height: 16.h),
              ],
            ),
          ),
          if (_isLoading)
            SliverToBoxAdapter(child: _buildShimmerList())
          else
            StreamBuilder<List<InboxItems>>(
              stream: _inboxController.stream,
              initialData: _inboxData ?? const [],
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverFillRemaining(child: _buildErrorState());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SliverFillRemaining(child: _buildEmptyState());
                }

                final displayData = _isSearching ? _filteredInboxData : snapshot.data!;

                if (_isSearching && displayData.isEmpty) {
                  return SliverFillRemaining(child: _buildNoSearchResults());
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildListItem(displayData[index], index),
                    childCount: displayData.length,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _handleSearch,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: 20.r,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey[400],
              size: 20.r,
            ),
            onPressed: () {
              _searchController.clear();
              _handleSearch('');
              FocusScope.of(context).unfocus();
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 110.h,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.h),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conversations',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            StreamBuilder<bool>(
              stream: WebSocketManager().connectionStream,
              initialData: WebSocketManager().isConnected,
              builder: (context, snapshot) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: snapshot.data! ? Colors.green : Colors.orange,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      snapshot.data! ? 'Connected' : 'Connecting...',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationTile(InboxItems conversation) {
    final bool isFirstPerson = chatUserId == (conversation.first_id != null ? int.parse(conversation.first_id!) : null);
    final String displayName = isFirstPerson ? conversation.second_name : conversation.first_name;
    final String displayImage = conversation.post?.image1 ??
        (isFirstPerson ? conversation.second_image ?? '' : conversation.first_image ?? '');
    final int unreadCount = isFirstPerson ? conversation.unread_messages_first : conversation.unread_messages_second;
    final bool hasUnread = unreadCount > 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: hasUnread ?
          ColorFilter.mode(const Color(0xFFFFF8E7).withOpacity(0.95), BlendMode.srcOver) :
          ColorFilter.mode(Colors.white, BlendMode.srcOver),
          child: Container(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                _buildAvatar(displayImage, hasUnread, conversation.id),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(displayName, conversation.time, hasUnread, unreadCount),
                      if (conversation.post != null) ...[
                        SizedBox(height: 4.h),
                        _buildPostInfo(conversation.post!),
                      ],
                      SizedBox(height: 4.h),
                      _buildMessagePreview(conversation.message, hasUnread),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String imageUrl, bool hasUnread, String id) {
    return Hero(
      tag: 'avatar_$id',
      child: Container(
        width: 60.r,
        height: 60.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: hasUnread
              ? Border.all(color: const Color(0xFFFFB800), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: imageUrl.isNotEmpty
              ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderIcon(),
          )
              : _buildPlaceholderIcon(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      color: Colors.grey[100],
      child: Icon(
        Icons.business,
        color: Colors.grey[300],
        size: 32.r,
      ),
    );
  }

  Widget _buildHeader(String name, String time, bool hasUnread, int unreadCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF2D2D2D),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            if (hasUnread)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB800),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(width: 8.w),
            Text(
              _formatDateTime(time),
              style: TextStyle(
                fontSize: 12.sp,
                color: hasUnread ? const Color(0xFFFFB800) : Colors.grey[500],
                fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPostInfo(PostDetails post) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.article_outlined,
            size: 14.r,
            color: Colors.grey[600],
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              post.title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagePreview(String? message, bool hasUnread) {
    return Row(
      children: [
        Expanded(
          child: Text(
            message ?? 'No messages yet',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              color: hasUnread ? const Color(0xFF2D2D2D) : Colors.grey[600],
              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
        if (hasUnread)
          Container(
            margin: EdgeInsets.only(left: 8.w),
            width: 8.r,
            height: 8.r,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB800),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  Widget _buildListItem(InboxItems conversation, int index) {
    final bool isSelected = _selectedIndex == index;

    return AnimatedScale(
      scale: isSelected ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _selectedIndex = index);
        },
        onTapUp: (_) {
          setState(() => _selectedIndex = null);
          Future.delayed(const Duration(milliseconds: 150), () {
            _navigateToChat(conversation);
          });
        },
        onTapCancel: () {
          setState(() => _selectedIndex = null);
        },
        child: _buildConversationTile(conversation),
      ),
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // Constrain the height
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 8,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                // Avatar placeholder
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name placeholder
                      Container(
                        width: 150.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Message placeholder
                      Container(
                        width: double.infinity,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Second line of message placeholder
                      Container(
                        width: 200.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                // Time placeholder
                Container(
                  width: 50.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
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
    final bool isFirstPerson = chatUserId ==
        (conversation.first_id != null ? int.parse(conversation.first_id!) : null);
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
                imageUrl: isFirstPerson
                    ? conversation.second_image ?? ''
                    : conversation.first_image ?? '',
                chatUserId: chatUserId,
                number: conversation.first_phone,
                isActive: isActive,
                lastActive: inactiveFrom,
                postId: conversation.post?.id,
                entityType: conversation.post?.entityType,
              ),
            ),
      ),
    ).then((_) {
      // Optional: You can also refresh here as a backup
      _refreshInboxData();
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
    routeObserver.unsubscribe(this);
    _searchController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    _inboxController.close();
    _messageSubscription.cancel();
    _connectionSubscription.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
