// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart' as path;
// import 'package:photo_view/photo_view.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'chat_screen_components.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:mime/mime.dart';
// import 'package:flutter_file_dialog/flutter_file_dialog.dart';
//
//
// class   AttachmentHandler {
//   static Future<Map<String, dynamic>?> pickAttachment(BuildContext context) async {
//     final result = await showModalBottomSheet<String>(
//       context: context,
//       builder: (BuildContext context) => AttachmentBottomSheet(),
//     );
//
//     if (result == null) return null;
//
//     switch (result) {
//       case 'image':
//         return await _pickImage();
//       case 'file':
//         return await _pickFile();
//       default:
//         return null;
//     }
//   }
//
//   static Future<Map<String, dynamic>?> _pickImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 70,
//       );
//
//       if (image == null) return null;
//
//       final bytes = await image.readAsBytes();
//       final base64Data = base64Encode(bytes);
//       final fileName = path.basename(image.path);
//       final fileExtension = path.extension(image.path).toLowerCase();
//
//       return {
//         'fileName': fileName,
//         'data': base64Data,
//         'type': 'image',
//         'fileExtension': fileExtension,
//         'size': bytes.length,
//       };
//     } catch (e) {
//       print('Error picking image: $e');
//       return null;
//     }
//   }
//
//   static Future<Map<String, dynamic>?> _pickFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//         withData: true,
//       );
//
//       if (result == null || result.files.isEmpty) return null;
//
//       final file = result.files.first;
//       if (file.bytes == null) return null;
//
//       final base64Data = base64Encode(file.bytes!);
//
//       return {
//         'fileName': file.name,
//         'data': base64Data,
//         'type': 'file',
//         'fileExtension': path.extension(file.name).toLowerCase(),
//         'size': file.size,
//       };
//     } catch (e) {
//       print('Error picking file: $e');
//       return null;
//     }
//   }
//
//   // Helper method to safely encode attachment data for WebSocket
//   static String? encodeAttachmentData(Map<String, dynamic> attachment) {
//     try {
//       // Create a new map with only the necessary data
//       final cleanAttachment = {
//         'fileName': attachment['fileName'],
//         'type': attachment['type'],
//         'fileExtension': attachment['fileExtension'],
//         'size': attachment['size'],
//         'data': attachment['data'],
//       };
//
//       // Double encode to ensure proper JSON formatting
//       return jsonEncode(cleanAttachment);
//     } catch (e) {
//       print('Error encoding attachment: $e');
//       return null;
//     }
//   }
//
//   // Helper method to safely decode attachment data
//   static Map<String, dynamic>? decodeAttachmentData(String attachmentString) {
//     try {
//       // Handle S3 URLs directly
//       if (attachmentString.startsWith('http')) {
//         return {
//           'type': 'file',
//           'url': attachmentString,
//           'fileName': path.basename(attachmentString),
//           'fileExtension': path.extension(attachmentString),
//         };
//       }
//
//       // Otherwise, decode the JSON data
//       final decoded = jsonDecode(attachmentString);
//       if (decoded is Map<String, dynamic>) {
//         return decoded;
//       }
//       return null;
//     } catch (e) {
//       print('Error decoding attachment: $e');
//       return null;
//     }
//   }
// }
//
// class AttachmentBottomSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Add Attachment',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildOption(
//                 context,
//                 icon: Icons.image,
//                 label: 'Image',
//                 onTap: () => Navigator.pop(context, 'image'),
//               ),
//               _buildOption(
//                 context,
//                 icon: Icons.attach_file,
//                 label: 'File',
//                 onTap: () => Navigator.pop(context, 'file'),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOption(
//       BuildContext context, {
//         required IconData icon,
//         required String label,
//         required VoidCallback onTap,
//       }) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               color: ChatColors.primary.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: ChatColors.primary, size: 30),
//           ),
//           SizedBox(height: 8),
//           Text(label),
//         ],
//       ),
//     );
//   }
// }
//
//
//   String _formatDateTime(String dateTimeStr) {
//     final dateTime = DateTime.parse(dateTimeStr).toLocal();
//     return DateFormat('hh:mm a').format(dateTime);
//   }
//
// class FullScreenAttachment extends StatelessWidget {
//   final Map<String, dynamic> attachment;
//
//   const FullScreenAttachment({
//     Key? key,
//     required this.attachment,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//           if (attachment['url'] != null)
//             IconButton(
//               icon: Icon(Icons.download),
//               onPressed: () async {
//                 final url = Uri.parse(attachment['url']);
//                 if (await canLaunchUrl(url)) {
//                   await launchUrl(url);
//                 }
//               },
//             ),
//         ],
//       ),
//       body: _buildContent(),
//     );
//   }
//
//   Widget _buildContent() {
//     if (attachment['type'] == 'image') {
//       return _buildImageView();
//     } else {
//       return _buildFileView();
//     }
//   }
//
//   Widget _buildImageView() {
//     if (attachment['url'] != null) {
//       return PhotoView(
//         imageProvider: CachedNetworkImageProvider(
//           attachment['url'],
//         ),
//         minScale: PhotoViewComputedScale.contained,
//         maxScale: PhotoViewComputedScale.covered * 2,
//         backgroundDecoration: BoxDecoration(color: Colors.black),
//         loadingBuilder: (context, event) => Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else if (attachment['data'] != null) {
//       try {
//         final bytes = base64Decode(attachment['data']);
//         return PhotoView(
//           imageProvider: MemoryImage(bytes),
//           minScale: PhotoViewComputedScale.contained,
//           maxScale: PhotoViewComputedScale.covered * 2,
//           backgroundDecoration: BoxDecoration(color: Colors.black),
//         );
//       } catch (e) {
//         return Center(
//           child: Text(
//             'Error loading image',
//             style: TextStyle(color: Colors.white),
//           ),
//         );
//       }
//     }
//     return Center(
//       child: Text(
//         'Image not available',
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildFileView() {
//     String getFileName(String url) {
//       return url.split('/').last.split('?').first;
//     }
//
//     final fileName = attachment['url'] != null
//         ? getFileName(attachment['url'])
//         : attachment['fileName'] ?? 'Unknown file';
//
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.insert_drive_file,
//               size: 100,
//               color: Colors.white,
//             ),
//             SizedBox(height: 20),
//             Text(
//               fileName,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             if (attachment['url'] != null) ...[
//               SizedBox(height: 30),
//               ElevatedButton.icon(
//                 icon: Icon(Icons.download),
//                 label: Text('Download File'),
//                 onPressed: () async {
//                   final url = Uri.parse(attachment['url']);
//                   if (await canLaunchUrl(url)) {
//                     await launchUrl(url);
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class AttachmentManager {
//   // Singleton pattern
//   static final AttachmentManager _instance = AttachmentManager._internal();
//   factory AttachmentManager() => _instance;
//   AttachmentManager._internal();
//
//   // Cache directory for temporary files
//   Directory? _cacheDir;
//
//   Future<void> init() async {
//     _cacheDir = await getTemporaryDirectory();
//   }
//
//   // Download and save attachment
//   Future<String?> downloadAttachment(String url, String fileName) async {
//     try {
//       // Request storage permission
//       if (!await _requestStoragePermission()) {
//         throw Exception('Storage permission denied');
//       }
//
//       // Download file
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode != 200) {
//         throw Exception('Failed to download file');
//       }
//
//       // Determine file type and appropriate directory
//       final mimeType = lookupMimeType(fileName) ?? 'application/octet-stream';
//       final isImage = mimeType.startsWith('image/');
//
//       // Use system file picker for saving
//       final params = SaveFileDialogParams(
//         data: response.bodyBytes,
//         fileName: fileName,
//         mimeTypesFilter: [mimeType],
//       );
//
//       final filePath = await FlutterFileDialog.saveFile(params: params);
//       return filePath;
//     } catch (e) {
//       print('Error downloading attachment: $e');
//       return null;
//     }
//   }
//
//   // Preview attachment
//   Future<File?> getCachedFile(String url, String fileName) async {
//     try {
//       if (_cacheDir == null) await init();
//
//       final cachedFile = File('${_cacheDir!.path}/$fileName');
//
//       // Return cached file if it exists
//       if (await cachedFile.exists()) {
//         return cachedFile;
//       }
//
//       // Download and cache file if it doesn't exist
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         await cachedFile.writeAsBytes(response.bodyBytes);
//         return cachedFile;
//       }
//
//       return null;
//     } catch (e) {
//       print('Error caching file: $e');
//       return null;
//     }
//   }
//
//   // Share attachment
//   Future<void> shareAttachment(String url, String fileName) async {
//     try {
//       final cachedFile = await getCachedFile(url, fileName);
//       if (cachedFile != null) {
//         final xFile = XFile(cachedFile.path);
//         await Share.shareXFiles(
//           [xFile],
//           subject: fileName,
//           text: 'Sharing $fileName',
//         );
//       }
//     } catch (e) {
//       print('Error sharing attachment: $e');
//     }
//   }
//
//   // Clear cache
//   Future<void> clearCache() async {
//     try {
//       if (_cacheDir == null) await init();
//       final files = _cacheDir!.listSync();
//       for (var file in files) {
//         await file.delete();
//       }
//     } catch (e) {
//       print('Error clearing cache: $e');
//     }
//   }
//
//   // Request storage permission
//   Future<bool> _requestStoragePermission() async {
//     if (Platform.isIOS) return true;  // iOS handles permissions differently
//
//     var status = await Permission.storage.status;
//     if (status.isDenied) {
//       status = await Permission.storage.request();
//     }
//     return status.isGranted;
//   }
// }
//
// // Enhanced AttachmentBubble widget
// class AttachmentBubble extends StatelessWidget {
//   final Map<String, dynamic> attachment;
//   final bool isFromUser;
//   final String time;
//   final AttachmentManager _attachmentManager = AttachmentManager();
//
//   AttachmentBubble({
//     Key? key,
//     required this.attachment,
//     required this.isFromUser,
//     required this.time,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: Align(
//         alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.7,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//               bottomLeft: Radius.circular(isFromUser ? 20 : 0),
//               bottomRight: Radius.circular(isFromUser ? 0 : 20),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 8,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildContent(context),
//               _buildActions(context),
//               _buildFooter(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(BuildContext context) {
//     final bool isImage = attachment['type'] == 'image';
//     final String url = attachment['url'] ?? '';
//     final String fileName = attachment['fileName'] ?? 'Unknown file';
//
//     return isImage
//         ? _buildImagePreview(context, url)
//         : _buildFilePreview(context, fileName, url);
//   }
//
//   Widget _buildImagePreview(BuildContext context, String url) {
//     return InkWell(
//       onTap: () => _showFullScreenImage(context, url),
//       child: Hero(
//         tag: url,
//         child: ClipRRect(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           child: Image.network(
//             url,
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: 200,
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) return child;
//               return Container(
//                 height: 200,
//                 color: Colors.grey[200],
//                 child: Center(child: CircularProgressIndicator()),
//               );
//             },
//             errorBuilder: (context, error, stackTrace) {
//               return Container(
//                 height: 200,
//                 color: Colors.grey[200],
//                 child: Icon(Icons.error_outline, color: Colors.red),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFilePreview(BuildContext context, String fileName, String url) {
//     return Padding(
//       padding: EdgeInsets.all(12),
//       child: Row(
//         children: [
//           Icon(Icons.insert_drive_file, color: Colors.blue, size: 24),
//           SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   fileName,
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Text(
//                   'Tap to preview',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActions(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // IconButton(
//           //   icon: Icon(Icons.download, size: 20),
//           //   onPressed: () => _downloadAttachment(context),
//           // ),
//           IconButton(
//             icon: Icon(Icons.share, size: 20),
//             onPressed: () => _shareAttachment(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFooter() {
//     return Padding(
//       padding: EdgeInsets.all(8),
//       child: Text(
//         time,
//         style: TextStyle(fontSize: 10, color: Colors.grey),
//       ),
//     );
//   }
//
//   void _showFullScreenImage(BuildContext context, String url) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FullScreenImage(imageUrl: url),
//       ),
//     );
//   }
//
//   Future<void> _downloadAttachment(BuildContext context) async {
//     final url = attachment['url'];
//     final fileName = attachment['fileName'];
//
//     if (url == null || fileName == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Invalid attachment')),
//       );
//       return;
//     }
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(child: CircularProgressIndicator()),
//     );
//
//     try {
//       final filePath = await _attachmentManager.downloadAttachment(url, fileName);
//
//       Navigator.pop(context); // Dismiss loading dialog
//
//       if (filePath != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('File saved successfully')),
//         );
//       } else {
//         throw Exception('Download failed');
//       }
//     } catch (e) {
//       Navigator.pop(context); // Dismiss loading dialog
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to download file')),
//       );
//     }
//   }
//
//   Future<void> _shareAttachment(BuildContext context) async {
//     final url = attachment['url'];
//     final fileName = attachment['fileName'];
//
//     if (url == null || fileName == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Invalid attachment')),
//       );
//       return;
//     }
//
//     try {
//       await _attachmentManager.shareAttachment(url, fileName);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to share file')),
//       );
//     }
//   }
// }
//
// // Full screen image viewer
// class FullScreenImage extends StatelessWidget {
//   final String imageUrl;
//
//   const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () async {
//               final fileName = imageUrl.split('/').last;
//               await AttachmentManager().downloadAttachment(imageUrl, fileName);
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.share),
//             onPressed: () async {
//               final fileName = imageUrl.split('/').last;
//               await AttachmentManager().shareAttachment(imageUrl, fileName);
//             },
//           ),
//         ],
//       ),
//       body: InteractiveViewer(
//         minScale: 0.5,
//         maxScale: 4.0,
//         child: Center(
//           child: Hero(
//             tag: imageUrl,
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.contain,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(child: CircularProgressIndicator());
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.error_outline, color: Colors.red, size: 48),
//                       SizedBox(height: 16),
//                       Text(
//                         'Failed to load image',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



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
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mime/mime.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class AttachmentHandler {
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

  static String? encodeAttachmentData(Map<String, dynamic> attachment) {
    try {
      final cleanAttachment = {
        'fileName': attachment['fileName'],
        'type': attachment['type'],
        'fileExtension': attachment['fileExtension'],
        'size': attachment['size'],
        'data': attachment['data'],
      };
      return jsonEncode(cleanAttachment);
    } catch (e) {
      print('Error encoding attachment: $e');
      return null;
    }
  }

  static Map<String, dynamic>? decodeAttachmentData(String attachmentString) {
    try {
      if (attachmentString.startsWith('http')) {
        return {
          'type': 'file',
          'url': attachmentString,
          'fileName': path.basename(attachmentString),
          'fileExtension': path.extension(attachmentString),
        };
      }
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

// Custom exception for permission handling
class PermissionException implements Exception {
  final String message;
  PermissionException(this.message);
}

// Progress dialog widget
class DownloadProgressDialog extends StatelessWidget {
  final ValueNotifier<double> progress;

  const DownloadProgressDialog({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Downloading...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (context, value, child) => LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentManager {
  static final AttachmentManager _instance = AttachmentManager._internal();
  factory AttachmentManager() => _instance;
  AttachmentManager._internal();

  Directory? _cacheDir;

  Future<void> init() async {
    _cacheDir = await getTemporaryDirectory();
  }

  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isIOS) return true;

    var status = await Permission.storage.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      final shouldOpenSettings = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Storage Permission Required'),
          content: Text(
            'Storage permission is needed to download files. Please enable it in app settings.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );

      if (shouldOpenSettings == true) {
        await openAppSettings();
        status = await Permission.storage.status;
        return status.isGranted;
      }
      return false;
    }

    status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<String?> downloadAttachment(BuildContext context, String url, String fileName) async {
    try {
      if (!await _requestStoragePermission(context)) {
        throw PermissionException('Storage permission required');
      }

      final downloadProgress = ValueNotifier<double>(0.0);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => DownloadProgressDialog(progress: downloadProgress),
      );

      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      if (response.statusCode != 200) {
        throw HttpException('Failed to download file');
      }

      final contentLength = response.contentLength ?? 0;
      var downloaded = 0;
      final bytes = <int>[];

      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
        downloaded += chunk.length;
        if (contentLength > 0) {
          downloadProgress.value = downloaded / contentLength;
        }
      }

      final mimeType = lookupMimeType(fileName) ?? 'application/octet-stream';

      final params = SaveFileDialogParams(
        data: Uint8List.fromList(bytes),
        fileName: fileName,
        mimeTypesFilter: [mimeType],
      );

      Navigator.of(context).pop();

      final filePath = await FlutterFileDialog.saveFile(params: params);
      return filePath;

    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  Future<File?> getCachedFile(String url, String fileName) async {
    try {
      if (_cacheDir == null) await init();

      final cachedFile = File('${_cacheDir!.path}/$fileName');

      if (await cachedFile.exists()) {
        return cachedFile;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await cachedFile.writeAsBytes(response.bodyBytes);
        return cachedFile;
      }

      return null;
    } catch (e) {
      print('Error caching file: $e');
      return null;
    }
  }

  Future<void> shareAttachment(String url, String fileName) async {
    try {
      final cachedFile = await getCachedFile(url, fileName);
      if (cachedFile != null) {
        final xFile = XFile(cachedFile.path);
        await Share.shareXFiles(
          [xFile],
          subject: fileName,
          text: 'Sharing $fileName',
        );
      }
    } catch (e) {
      print('Error sharing attachment: $e');
    }
  }

  Future<void> clearCache() async {
    try {
      if (_cacheDir == null) await init();
      final files = _cacheDir!.listSync();
      for (var file in files) {
        await file.delete();
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}

class AttachmentBubble extends StatelessWidget {
  final Map<String, dynamic> attachment;
  final bool isFromUser;
  final String time;
  final AttachmentManager _attachmentManager = AttachmentManager();

  AttachmentBubble({
    Key? key,
    required this.attachment,
    required this.isFromUser,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Align(
        alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
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
              _buildContent(context),
              _buildActions(context),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final bool isImage = attachment['type'] == 'image';
    final String url = attachment['url'] ?? '';
    final String fileName = attachment['fileName'] ?? 'Unknown file';

    return isImage
        ? _buildImagePreview(context, url)
        : _buildFilePreview(context, fileName, url);
  }

  Widget _buildImagePreview(BuildContext context, String url) {
    return InkWell(
        onTap: () => _showFullScreenImage(context, url),
        child: Hero(
            tag: url,
            child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    child: Image.network(
    url,
    fit: BoxFit.cover,
    width: double.infinity,
    height: 200,
    loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return Container(
    height: 200,
    color: Colors.grey[200],
    child: Center(child: CircularProgressIndicator()),
    );
    },
    errorBuilder: (context, error, stackTrace) {
    return Container(
    height: 200,
    color: Colors.grey[200],
      child: Icon(Icons.error_outline, color: Colors.red),
    );
    },
    ),
            ),
        ),
    );
  }

  Widget _buildFilePreview(BuildContext context, String fileName, String url) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file, color: Colors.blue, size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Tap to preview',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.share, size: 20),
            onPressed: () => _shareAttachment(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        time,
        style: TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: url),
      ),
    );
  }

  Future<void> _downloadAttachment(BuildContext context) async {
    final url = attachment['url'];
    final fileName = attachment['fileName'];

    if (url == null || fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid attachment')),
      );
      return;
    }

    try {
      final filePath = await _attachmentManager.downloadAttachment(context, url, fileName);
      if (filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File saved successfully')),
        );
      }
    } catch (e) {
      print('Download error: $e');
    }
  }

  Future<void> _shareAttachment(BuildContext context) async {
    final url = attachment['url'];
    final fileName = attachment['fileName'];

    if (url == null || fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid attachment')),
      );
      return;
    }

    try {
      await _attachmentManager.shareAttachment(url, fileName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share file')),
      );
    }
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              final fileName = imageUrl.split('/').last;
              await AttachmentManager().downloadAttachment(
                context,
                imageUrl,
                fileName,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final fileName = imageUrl.split('/').last;
              await AttachmentManager().shareAttachment(imageUrl, fileName);
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'Failed to load image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}