import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../Views/chat_screens/websocket integration.dart';
import '../generated/constants.dart';

class ChatFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ChatFloatingActionButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ChatFloatingActionButton> createState() => _ChatFloatingActionButtonState();
}

class _ChatFloatingActionButtonState extends State<ChatFloatingActionButton> {
  final WebSocketManager _webSocketManager = WebSocketManager();
  bool _hasUnreadMessages = false;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _setupWebSocketListeners();
  }

  void _setupWebSocketListeners() {
    _connectionSubscription = _webSocketManager.connectionStream.listen((isConnected) {
      if (isConnected) {
        print('WebSocket connected in FAB');
      } else {
        print('WebSocket disconnected in FAB');
      }
    });

    _messageSubscription = _webSocketManager.messageStream.listen((message) {
      if (message is String) {
        try {
          final data = jsonDecode(message);
          if (data['type'] == 'room_update' && data['room'] != null) {
            final roomData = data['room'];
            if (roomData['total_unread'] != null) {
              setState(() {
                _hasUnreadMessages = roomData['total_unread'] > 0;
              });
            }
          }
        } catch (e) {
          print('Error parsing WebSocket message: $e');
        }
      }
    });

    if (!_webSocketManager.isConnected) {
      _webSocketManager.connect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 56, // Standard FAB size
        height: 56,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton(
              heroTag: 'chat_fab',
              onPressed: widget.onPressed,
              backgroundColor: Colors.white,
              elevation: 2,
              shape: const CircleBorder(),
              child: Icon(
                Icons.chat_bubble_outline, // Changed to outlined chat icon
                color: buttonColor,
                size: 26,
              ),
            ),
            if (_hasUnreadMessages)
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }
}