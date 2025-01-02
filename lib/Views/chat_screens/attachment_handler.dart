import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_screen_components.dart';


class   AttachmentHandler {
  static Future<Map<String, dynamic>?> pickAttachment(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => AttachmentBottomSheet(),
    );

    if (result == null) return null;

    switch (result) {
      case 'image':
        return await _pickImage();
      case 'file':
        return await _pickFile();
      default:
        return null;
    }
  }

  static Future<Map<String, dynamic>?> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image == null) return null;

      final bytes = await image.readAsBytes();
      final base64Data = base64Encode(bytes);
      final fileName = path.basename(image.path);
      final fileExtension = path.extension(image.path).toLowerCase();

      return {
        'fileName': fileName,
        'data': base64Data,
        'type': 'image',
        'fileExtension': fileExtension,
        'size': bytes.length,
      };
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;
      if (file.bytes == null) return null;

      final base64Data = base64Encode(file.bytes!);

      return {
        'fileName': file.name,
        'data': base64Data,
        'type': 'file',
        'fileExtension': path.extension(file.name).toLowerCase(),
        'size': file.size,
      };
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  // Helper method to safely encode attachment data for WebSocket
  static String? encodeAttachmentData(Map<String, dynamic> attachment) {
    try {
      // Create a new map with only the necessary data
      final cleanAttachment = {
        'fileName': attachment['fileName'],
        'type': attachment['type'],
        'fileExtension': attachment['fileExtension'],
        'size': attachment['size'],
        'data': attachment['data'],
      };

      // Double encode to ensure proper JSON formatting
      return jsonEncode(cleanAttachment);
    } catch (e) {
      print('Error encoding attachment: $e');
      return null;
    }
  }

  // Helper method to safely decode attachment data
  static Map<String, dynamic>? decodeAttachmentData(String attachmentString) {
    try {
      // Handle S3 URLs directly
      if (attachmentString.startsWith('http')) {
        return {
          'type': 'file',
          'url': attachmentString,
          'fileName': path.basename(attachmentString),
          'fileExtension': path.extension(attachmentString),
        };
      }

      // Otherwise, decode the JSON data
      final decoded = jsonDecode(attachmentString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return null;
    } catch (e) {
      print('Error decoding attachment: $e');
      return null;
    }
  }
}

class AttachmentBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Attachment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOption(
                context,
                icon: Icons.image,
                label: 'Image',
                onTap: () => Navigator.pop(context, 'image'),
              ),
              _buildOption(
                context,
                icon: Icons.attach_file,
                label: 'File',
                onTap: () => Navigator.pop(context, 'file'),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: ChatColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ChatColors.primary, size: 30),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class AttachmentBubble extends StatelessWidget {
  final dynamic attachment;
  final bool isFromUser;
  final String time;

  const AttachmentBubble({
    Key? key,
    required this.attachment,
    required this.isFromUser,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("attached data is $attachment");
    // Safely convert attachment to Map if it isn't already
    Map<String, dynamic> attachmentData = {};

    if (attachment is String) {
      try {
        attachmentData = Map<String, dynamic>.from(jsonDecode(attachment));
      } catch (e) {
        print('Error decoding attachment string: $e');
        attachmentData = {'error': true};
      }
    } else if (attachment is Map) {
      attachmentData = Map<String, dynamic>.from(attachment);
    }

    // Rest of your build method remains the same
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width * 0.7,
          ),
          decoration: BoxDecoration(
            color: isFromUser ? Colors.white : Colors.white, // Both white now
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(isFromUser ? 20 : 0),
              bottomRight: Radius.circular(isFromUser ? 0 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (attachmentData['type'] == 'image')
                _buildImagePreview(context, attachmentData)
              else
                _buildFilePreview(context, attachmentData),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, Map<String, dynamic> attachmentData) {
    if (attachmentData['url'] != null) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenAttachment(attachment: attachmentData),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: CachedNetworkImage(
            imageUrl: attachmentData['url'],
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
            placeholder: (context, url) => Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[200],
              child: Icon(Icons.error_outline, color: Colors.red),
            ),
          ),
        ),
      );
    } else {  // Add else block to return a Widget in all cases
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[200],
        child: Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }


  Widget _buildFilePreview(BuildContext context,Map<String, dynamic> attachmentData) {
    print("attached data os $attachmentData");
    String getFileName(url) {
      return url.split('/').last.split('?').first;
    }
    final fileName = getFileName(attachmentData['url']) ?? 'Unknown file';
    final fileSize = attachmentData['size'] ?? 0;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenAttachment(attachment: attachmentData),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              color: isFromUser ? Colors.white70 : ChatColors.primary,
              size: 24,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      color: isFromUser ? ChatColors.primary : ChatColors.primary, // Yellow for both
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _formatFileSize(fileSize),
                    style: TextStyle(
                      color: isFromUser ? ChatColors.primary : ChatColors.primary, // Yellow for both
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        _formatDateTime(time),
        style: TextStyle(
          fontSize: 10,
          color: isFromUser ? ChatColors.primary : ChatColors.primary, // Yellow for both
        ),
      ),
    );
  }
}

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr).toLocal();
    return DateFormat('hh:mm a').format(dateTime);
  }

class FullScreenAttachment extends StatelessWidget {
  final Map<String, dynamic> attachment;

  const FullScreenAttachment({
    Key? key,
    required this.attachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (attachment['url'] != null)
            IconButton(
              icon: Icon(Icons.download),
              onPressed: () async {
                final url = Uri.parse(attachment['url']);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (attachment['type'] == 'image') {
      return _buildImageView();
    } else {
      return _buildFileView();
    }
  }

  Widget _buildImageView() {
    if (attachment['url'] != null) {
      return PhotoView(
        imageProvider: CachedNetworkImageProvider(
          attachment['url'],
        ),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: BoxDecoration(color: Colors.black),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (attachment['data'] != null) {
      try {
        final bytes = base64Decode(attachment['data']);
        return PhotoView(
          imageProvider: MemoryImage(bytes),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          backgroundDecoration: BoxDecoration(color: Colors.black),
        );
      } catch (e) {
        return Center(
          child: Text(
            'Error loading image',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    }
    return Center(
      child: Text(
        'Image not available',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildFileView() {
    String getFileName(String url) {
      return url.split('/').last.split('?').first;
    }

    final fileName = attachment['url'] != null
        ? getFileName(attachment['url'])
        : attachment['fileName'] ?? 'Unknown file';

    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_drive_file,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              fileName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (attachment['url'] != null) ...[
              SizedBox(height: 30),
              ElevatedButton.icon(
                icon: Icon(Icons.download),
                label: Text('Download File'),
                onPressed: () async {
                  final url = Uri.parse(attachment['url']);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}