import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_emergio/Views/chat_screens/voice_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../services/messages get service.dart';
import 'attachment_handler.dart';
import 'chat_screen_components.dart';
import 'composer.dart';


class ChatScreen extends StatefulWidget {
  final String roomId;
  final String name;
  final String number;
  final String lastActive;
  final bool isActive;
  final String? imageUrl;
  final int? chatUserId;

  const ChatScreen({
    Key? key,
    required this.roomId,
    required this.name,
    this.imageUrl,
    this.chatUserId,
    required this.number,
    required this.lastActive,
    required this.isActive,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  late WebSocketChannel channel;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> messages = [];
  String? token;
  bool isLoading = true;
  bool hasError = false;
  final ScrollController _scrollController = ScrollController();
  bool isEmojiVisible = false;
  final FocusNode _focusNode = FocusNode();
  String? phoneNumber;
  bool _isRecording = false;
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;
  final VoiceMessageHandler _voiceMessageHandler = VoiceMessageHandler();
  String? _currentlyPlayingPath;
  bool _isSendingVoice = false;

  // New variables for scroll button
  bool _showScrollButton = false;
  int _unreadCount = 0;
  bool _isNearBottom = true;

  @override
  void initState() {
    super.initState();
    _initializeWebSocketConnection();
    _fetchMessages();
    _initializeVoiceHandler();
    _initializeScrollController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
  }

  void _initializeScrollController() {
    _scrollController.addListener(() {
      setState(() {
        // Show button when scrolled up more than 200 pixels
        _showScrollButton = _scrollController.offset >= 200;

        // Reset unread count only when actually at the bottom
        if (!_showScrollButton) {
          _unreadCount = 0;
        }
      });
    });
  }

  void _initializeVoiceHandler() {
    _voiceMessageHandler.onPlayComplete = () {
      if (mounted) {
        setState(() {
          _currentlyPlayingPath = null;
        });
      }
    };
  }

  Future<void> _fetchMessages() async {
    try {
      MessageDataResponse? response = await MessageService.fetchMessageData(widget.roomId);

      if (response != null) {
        setState(() {
          messages.addAll(response.messages.map((message) {
            Map<String, String> messageData = {
              'sendedBy': message.sendedBy,
              'sendedTo': message.sendedTo,
              'time': message.time ?? DateTime.now().toIso8601String(),
            };

            if (message.audioData != null) {
              messageData['audio'] = message.audioData!;
              messageData['messageType'] = 'voice';
              messageData['message'] = 'voice message';
              messageData['duration'] = message.duration ?? '0';
            } else if (message.attachment != null) {
              messageData['messageType'] = 'attachment';
              messageData['attachment'] = jsonEncode(message.attachment);
              messageData['message'] = 'Attachment';
            } else {
              messageData['message'] = message.message ?? '';
              messageData['messageType'] = 'text';
            }

            return messageData;
          }));

          phoneNumber = response.phoneNumber;
          isLoading = false;
        });
        _scrollToBottom();
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _handleNewMessage(Map<String, String> messageData) {
    setState(() {
      messages.insert(0, messageData);
      if (!_showScrollButton) {
        _scrollToBottom();
      } else {
        _unreadCount++;
      }
    });
  }

  Future<void> _initializeWebSocketConnection() async {
    try {
      token = await _storage.read(key: 'token');

      if (token != null) {
        channel = WebSocketChannel.connect(
          Uri.parse('wss://test.investryx.com/${widget.roomId}?token=$token'),
        );

        channel.stream.listen((message) {
          try {
            final data = jsonDecode(message);
            if (data['token'] != null && data['roomId'] == widget.roomId) {
              Map<String, String> messageData = {
                'sendedBy': (data['sendedBy'] ?? '').toString(),
                'sendedTo': (data['sendedTo'] ?? '').toString(),
                'time': data['time'] ?? DateTime.now().toIso8601String(),
              };

              switch (data['messageType']) {
                case 'voice':
                  messageData['audio'] = data['audio'].toString();
                  messageData['duration'] = (data['duration'] ?? '0').toString();
                  messageData['messageType'] = 'voice';
                  messageData['message'] = 'Voice Message';
                  break;

                case 'attachment':
                  if (data['attachment'] != null) {
                    messageData['messageType'] = 'attachment';
                    messageData['attachment'] = jsonEncode(data['attachment']);
                    messageData['message'] = 'Attachment';
                  }
                  break;

                default:
                  messageData['message'] = data['message'] ?? '';
                  messageData['messageType'] = 'text';
              }

              _handleNewMessage(messageData);
            }
          } catch (e) {
            print('Error processing WebSocket message: $e');
          }
        }, onError: (error) {
          print('WebSocket Error: $error');
          _showSnackBar('Connection error occurred');
        }, cancelOnError: false);
      } else {
        _showSnackBar('Token not found. Please login again.');
      }
    } catch (e) {
      print('Error initializing WebSocket: $e');
      _showSnackBar('Failed to establish connection');
    }
  }


  Future<void> sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      _showSnackBar('The message is empty');
    } else {
      if (token != null) {
        final data = jsonEncode({
          'token': token,
          'message': message,
          'roomId': widget.roomId
        });

        channel.sink.add(data);
        _messageController.clear();
        _scrollToBottom();
      } else {
        _showSnackBar('Token not found. Please login again.');
      }
    }
  }

  Future<void> _startVoiceMessage() async {
    if (!_isRecording) {
      try {
        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
        });

        await _voiceMessageHandler.startRecording();
        _startRecordingTimer();
      } catch (e) {
        print('Error starting voice recording: $e');
        setState(() {
          _isRecording = false;
        });
        _showSnackBar('Failed to start recording');
      }
    }
  }

  void _startRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  // Future<void> _initializeWebSocketConnection() async {
  //   try {
  //     token = await _storage.read(key: 'token');
  //
  //     if (token != null) {
  //       channel = WebSocketChannel.connect(
  //         Uri.parse('wss://test.investryx.com/${widget.roomId}?token=$token'),
  //       );
  //
  //       channel.stream.listen((message) {
  //         try {
  //           final data = jsonDecode(message);
  //           if (data['token'] != null && data['roomId'] == widget.roomId) {
  //             setState(() {
  //               Map<String, String> messageData = {
  //                 'sendedBy': (data['sendedBy'] ?? '').toString(),
  //                 'sendedTo': (data['sendedTo'] ?? '').toString(),
  //                 'time': data['time'] ?? DateTime.now().toIso8601String(),
  //               };
  //
  //               // Handle different message types
  //               switch (data['messageType']) {
  //                 case 'voice':
  //                   messageData['audio'] = data['audio'].toString();
  //                   messageData['duration'] = (data['duration'] ?? '0').toString();
  //                   messageData['messageType'] = 'voice';
  //                   messageData['message'] = 'Voice Message';
  //                   break;
  //
  //                 case 'attachment':
  //                   // final attachmentData = AttachmentHandler.decodeAttachmentData(data['attachment']);
  //                   if (data['attachment'] != null) {
  //                     messageData['messageType'] = 'attachment';
  //                     messageData['attachment'] = jsonEncode(data['attachment']);
  //                     messageData['message'] = 'Attachment';
  //                   }
  //                   break;
  //
  //
  //                 default: // Text message
  //                   messageData['message'] = data['message'] ?? '';
  //                   messageData['messageType'] = 'text';
  //               }
  //
  //               messages.insert(0, messageData);
  //             });
  //             _scrollToBottom();
  //           }
  //         } catch (e) {
  //           print('Error processing WebSocket message: $e');
  //         }
  //       }, onError: (error) {
  //         print('WebSocket Error: $error');
  //         _showSnackBar('Connection error occurred');
  //       }, cancelOnError: false);
  //     } else {
  //       _showSnackBar('Token not found. Please login again.');
  //     }
  //   } catch (e) {
  //     print('Error initializing WebSocket: $e');
  //     _showSnackBar('Failed to establish connection');
  //   }
  // }

  Future<void> _stopVoiceMessage() async {
    if (_isRecording) {
      try {
        final audioPath = await _voiceMessageHandler.stopRecording();
        _recordingTimer?.cancel();

        setState(() {
          _isRecording = false;
        });

        if (audioPath != null && token != null) {
          setState(() {
            _isSendingVoice = true;
          });

          try {
            final bytes = await File(audioPath).readAsBytes();
            final base64Audio = base64Encode(bytes);

            final data = jsonEncode({
              'token': token,
              'audio': base64Audio,
              'roomId': widget.roomId,
              'messageType': 'voice',
              'duration': _recordingDuration.inSeconds.toString(),
              'time': DateTime.now().toIso8601String(),
            });

            channel.sink.add(data);

          } catch (e) {
            print('Error sending voice message: $e');
            _showSnackBar('Failed to send voice message');
          } finally {
            setState(() {
              _isSendingVoice = false;
            });
          }
        }
      } catch (e) {
        print('Error stopping recording: $e');
        _showSnackBar('Failed to stop recording');
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  Future<void> _handleVoiceMessagePlay(String path) async {
    print('paaath issss ${path}');
    if (path.isEmpty) {
      _showSnackBar('Audio file not available');
      return;
    }

    try {
      setState(() {
        if (_currentlyPlayingPath == path) {
          _currentlyPlayingPath = null;
          _voiceMessageHandler.stopPlaying();
        } else {
          _currentlyPlayingPath = path;
          _voiceMessageHandler.playVoiceMessage(path).then((_) {
            // Success case
          }).catchError((error) {
            print('Error playing audio: $error');
            _showSnackBar('Failed to play audio');
            setState(() {
              _currentlyPlayingPath = null;
            });
          });
        }
      });
    } catch (e) {
      print('Error handling voice message play: $e');
      _showSnackBar('Error playing voice message');
      setState(() {
        _currentlyPlayingPath = null;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  //
  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   channel.sink.close();
  //   _voiceMessageHandler.dispose();
  //   _recordingTimer?.cancel();
  //   _messageController.dispose();
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final Color primaryYellow = const Color(0xFFFFD700);
    final Color darkYellow = const Color(0xFFFFB800);

    return GestureDetector(
      onTap: () {
        if (isEmojiVisible) {
          setState(() {
            isEmojiVisible = false;
          });
        }
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: ChatAppBar(
          name: widget.name,
          imageUrl: widget.imageUrl,
          roomId: widget.roomId,
          phoneNumber: phoneNumber,
          isActive: widget.isActive,
          lastActive: widget.lastActive,
          onBackPress: () => Navigator.of(context).pop(),
          onPhonePress: (number) => ChatUtils.makePhoneCall(context, number),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                ChatDateHeader(),
                Expanded(
                  child: isLoading
                      ? ChatShimmerEffect()
                      : hasError
                      ? ChatErrorState()
                      : ChatMessagesList(
                    messages: messages,
                    scrollController: _scrollController,
                    chatUserId: widget.chatUserId,
                    onPlayVoiceMessage: _handleVoiceMessagePlay,
                    currentlyPlayingPath: _currentlyPlayingPath,
                  ),
                ),
                ChatMessageComposer(
                  messageController: _messageController,
                  focusNode: _focusNode,
                  isRecording: _isRecording,
                  onSendMessage: sendMessage,
                  onVoiceMessageStart: _startVoiceMessage,
                  onVoiceMessageEnd: _stopVoiceMessage,
                  onAttachmentSelected: (attachment) {
                    final data = jsonEncode({
                      'token': token,
                      'messageType': 'attachment',
                      'attachment': jsonEncode(attachment),
                      'roomId': widget.roomId,
                      'time': DateTime.now().toIso8601String(),
                    });
                    channel.sink.add(data);
                  },
                ),
              ],
            ),
            if (_showScrollButton)
              Positioned(
                right: 16,
                bottom: 80,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      _scrollToBottom();
                      setState(() {
                        _unreadCount = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryYellow,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: darkYellow.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black87,
                            size: 20,
                          ),
                          if (_unreadCount > 0) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _unreadCount.toString(),
                                style: TextStyle(
                                  color: darkYellow,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
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
    _focusNode.dispose();
    channel.sink.close();
    _voiceMessageHandler.dispose();
    _recordingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}