import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'chat_screen_components.dart';


class ChatMessageComposer extends StatefulWidget {
  final TextEditingController messageController;
  final FocusNode focusNode;
  final bool isRecording;
  final VoidCallback onSendMessage;
  final VoidCallback onVoiceMessageStart;
  final VoidCallback onVoiceMessageEnd;
  final Function(Map<String, dynamic>)? onAttachmentSelected;

  const ChatMessageComposer({
    Key? key,
    required this.messageController,
    required this.focusNode,
    required this.isRecording,
    required this.onSendMessage,
    required this.onVoiceMessageStart,
    required this.onVoiceMessageEnd,
    this.onAttachmentSelected,
  }) : super(key: key);

  @override
  _ChatMessageComposerState createState() => _ChatMessageComposerState();
}

class _ChatMessageComposerState extends State<ChatMessageComposer> {
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  bool _isDraggingToCancel = false;
  double _dragStartX = 0;
  bool _showSendButton = false;

  @override
  void initState() {
    super.initState();
    _showSendButton = widget.messageController.text.isNotEmpty;
    widget.messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.messageController.removeListener(_onTextChanged);
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.messageController.text.isNotEmpty;
    if (_showSendButton != hasText) {
      setState(() {
        _showSendButton = hasText;
      });
    }
  }

  void _startRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration += const Duration(seconds: 1);
      });
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    setState(() {
      _recordingDuration = Duration.zero;
    });
  }

  void _handleVoiceMessageStart() {
    widget.onVoiceMessageStart();
    _startRecordingTimer();
    setState(() {
      _isDraggingToCancel = false;
    });
  }

  void _handleVoiceMessageEnd() {
    if (!_isDraggingToCancel) {
      widget.onVoiceMessageEnd();
    }
    _stopRecordingTimer();
    setState(() {
      _isDraggingToCancel = false;
    });
  }

  Future<void> _handleAttachmentSelection(String type) async {
    try {
      Map<String, dynamic>? attachment;

      if (type == 'gallery' || type == 'camera') {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: type == 'gallery' ? ImageSource.gallery : ImageSource.camera,
          imageQuality: 70,
        );

        if (image != null) {
          final bytes = await image.readAsBytes();
          final base64Data = base64Encode(bytes);
          attachment = {
            'fileName': path.basename(image.path),
            'data': base64Data,
            'type': 'image',
            'fileExtension': path.extension(image.path).toLowerCase(),
            'size': bytes.length,
          };
        }
      } else if (type == 'document') {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          allowMultiple: false,
          withData: true,
        );

        if (result != null && result.files.isNotEmpty) {
          final file = result.files.first;
          if (file.bytes != null) {
            attachment = {
              'fileName': file.name,
              'data': base64Encode(file.bytes!),
              'type': 'file',
              'fileExtension': path.extension(file.name).toLowerCase(),
              'size': file.size,
            };
          }
        }
      }
  log('attaachment  $attachment');
      if (attachment != null && widget.onAttachmentSelected != null) {
        widget.onAttachmentSelected!(attachment);
      }
    } catch (e) {
      print('Error handling attachment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process attachment')),
        );
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (widget.isRecording) _buildRecordingIndicator(),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded),
                  color: ChatColors.subtleText,
                  onPressed: () => _showAttachmentBottomSheet(context),
                ),
                Expanded(
                  child: _buildMessageInput(context),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _showSendButton ? _buildSendButton() : _buildVoiceButton(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ChatColors.messageBubble,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: ChatColors.primaryLight,
          width: 1,
        ),
      ),
      child: TextField(
        controller: widget.messageController,
        focusNode: widget.focusNode,
        enabled: !widget.isRecording,
        decoration: InputDecoration(
          hintText: widget.isRecording
              ? 'Recording voice message...'
              : 'Type a message...',
          hintStyle: TextStyle(color: ChatColors.subtleText),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        style: TextStyle(
          color: ChatColors.text,
          fontSize: 16.sp,
        ),
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) {
          if (widget.messageController.text.trim().isNotEmpty) {
            widget.onSendMessage();
          }
        },
      ),
    );
  }

  Widget _buildVoiceButton() {
    return GestureDetector(
      onLongPressStart: (details) {
        _dragStartX = details.globalPosition.dx;
        _handleVoiceMessageStart();
      },
      onLongPressMoveUpdate: (details) {
        if (widget.isRecording) {
          final dragDistance = details.globalPosition.dx - _dragStartX;
          setState(() {
            _isDraggingToCancel = dragDistance < -50;
          });
        }
      },
      onLongPressEnd: (_) => _handleVoiceMessageEnd(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isRecording ? Colors.red.withOpacity(0.1) : ChatColors.primary,
        ),
        child: Icon(
          widget.isRecording ? Icons.mic : Icons.mic_none,
          color: widget.isRecording ? Colors.red : Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ChatColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ChatColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.onSendMessage,
          child: const Icon(
            Icons.send,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Recording ${_formatDuration(_recordingDuration)}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            _isDraggingToCancel ? 'Release to cancel' : '← Slide to cancel',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _showAttachmentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.image,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () => _handleAttachmentSelection('gallery'),
                ),
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.red,
                  onTap: () => _handleAttachmentSelection('camera'),
                ),
                _buildAttachmentOption(
                  context: context,
                  icon: Icons.insert_drive_file,
                  label: 'Document',
                  color: Colors.blue,
                  onTap: () => _handleAttachmentSelection('document'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}