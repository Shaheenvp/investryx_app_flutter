// import 'dart:async';
// import 'dart:convert';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class WebSocketManager {
//   static final WebSocketManager _instance = WebSocketManager._internal();
//   factory WebSocketManager() => _instance;
//   WebSocketManager._internal();
//
//   WebSocketChannel? channel;
//   final storage = const FlutterSecureStorage();
//   Timer? pingTimer;
//   Timer? reconnectTimer;
//   bool isConnected = false;
//   bool _isReconnecting = false;
//   int _reconnectAttempts = 0;
//   static const int maxReconnectAttempts = 5;
//   static const int reconnectDelay = 5; // seconds
//
//   final _messageController = StreamController<dynamic>.broadcast();
//   final _connectionController = StreamController<bool>.broadcast();
//
//   Stream<dynamic> get messageStream => _messageController.stream;
//   Stream<bool> get connectionStream => _connectionController.stream;
//
//   Future<void> connect() async {
//     if (channel != null && isConnected) {
//       print('WebSocket already connected');
//       return;
//     }
//
//     try {
//       String? token = await storage.read(key: 'token');
//       if (token == null) {
//         print('Token not found. Please login again.');
//         return;
//       }
//
//       channel = WebSocketChannel.connect(
//         Uri.parse('wss://test.investryx.com/rooms?token=$token'),
//       );
//
//       channel!.stream.listen(
//             (message) {
//           _messageController.add(message);
//           _reconnectAttempts = 0; // Reset reconnect attempts on successful message
//         },
//         onError: (error) {
//           print('WebSocket error: $error');
//           _handleError();
//         },
//         onDone: () {
//           print('WebSocket connection closed');
//           _handleError();
//         },
//         cancelOnError: false,
//       );
//
//       isConnected = true;
//       _connectionController.add(true);
//       _startPingTimer();
//       print('WebSocket connected successfully');
//     } catch (e) {
//       print('Connection error: $e');
//       _handleError();
//     }
//   }
//
//   void _handleError() {
//     isConnected = false;
//     _connectionController.add(false);
//     _stopPingTimer();
//
//     if (!_isReconnecting && _reconnectAttempts < maxReconnectAttempts) {
//       _startReconnectProcess();
//     } else if (_reconnectAttempts >= maxReconnectAttempts) {
//       print('Max reconnection attempts reached');
//       _isReconnecting = false;
//       _reconnectAttempts = 0;
//       // Implement your failure handling logic here
//     }
//   }
//
//   void _startReconnectProcess() {
//     _isReconnecting = true;
//     _reconnectAttempts++;
//
//     print('Attempting to reconnect (Attempt $_reconnectAttempts of $maxReconnectAttempts)');
//
//     reconnectTimer?.cancel();
//     reconnectTimer = Timer(Duration(seconds: reconnectDelay), () async {
//       if (!isConnected) {
//         channel?.sink.close();
//         channel = null;
//         await connect();
//       }
//     });
//   }
//
//   void _startPingTimer() {
//     pingTimer?.cancel();
//     pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
//       if (channel != null && isConnected) {
//         channel!.sink.add(jsonEncode({'type': 'ping'}));
//       }
//     });
//   }
//
//   void _stopPingTimer() {
//     pingTimer?.cancel();
//     pingTimer = null;
//   }
//
//   void sendMessage(String message) {
//     if (channel != null && isConnected) {
//       channel!.sink.add(message);
//     }
//   }
//
//   void dispose() {
//     reconnectTimer?.cancel();
//     channel?.sink.close();
//     channel = null;
//     isConnected = false;
//     _isReconnecting = false;
//     _reconnectAttempts = 0;
//     _stopPingTimer();
//     _messageController.close();
//     _connectionController.close();
//   }
// }



import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  factory WebSocketManager() => _instance;
  WebSocketManager._internal();

  WebSocketChannel? channel;
  final storage = const FlutterSecureStorage();
  Timer? pingTimer;
  Timer? reconnectTimer;
  bool isConnected = false;
  bool _isReconnecting = false;
  int _reconnectAttempts = 0;

  // Configuration constants
  static const int maxReconnectAttempts = 5;
  static const int initialReconnectDelay = 1; // seconds
  static const int maxReconnectDelay = 30; // maximum delay in seconds

  final _messageController = StreamController<dynamic>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<dynamic> get messageStream => _messageController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  Future<void> connect() async {
    if (channel != null && isConnected) {
      print('WebSocket already connected');
      return;
    }

    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        print('Token not found. Please login again.');
        return;
      }

      channel = WebSocketChannel.connect(
        Uri.parse('wss://test.investryx.com/rooms?token=$token'),
      );

      channel!.stream.listen(
            (message) {
          _messageController.add(message);
          _reconnectAttempts = 0; // Reset reconnect attempts on successful message
        },
        onError: (error) {
          print('WebSocket error: $error');
          _handleDisconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          _handleDisconnect();
        },
        cancelOnError: false,
      );

      isConnected = true;
      _connectionController.add(true);
      _startPingTimer();
      print('WebSocket connected successfully');
    } catch (e) {
      print('Connection error: $e');
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    isConnected = false;
    _connectionController.add(false);
    _stopPingTimer();

    if (!_isReconnecting) {
      _startReconnectProcess();
    }
  }

  void _startReconnectProcess() {
    if (_isReconnecting) return;

    _isReconnecting = true;
    _attemptReconnect();
  }

  Future<void> _attemptReconnect() async {
    if (isConnected || _reconnectAttempts >= maxReconnectAttempts) {
      _isReconnecting = false;
      if (_reconnectAttempts >= maxReconnectAttempts) {
        print('Max reconnection attempts reached');
        _reconnectAttempts = 0;
        // Implement additional failure handling here if needed
      }
      return;
    }

    _reconnectAttempts++;
    print('Attempting to reconnect (Attempt $_reconnectAttempts of $maxReconnectAttempts)');

    // Calculate exponential backoff delay with maximum limit
    int delaySeconds = _calculateBackoffDelay();
    print('Waiting $delaySeconds seconds before reconnecting...');

    reconnectTimer?.cancel();
    reconnectTimer = Timer(Duration(seconds: delaySeconds), () async {
      try {
        channel?.sink.close();
        channel = null;
        await connect();

        if (!isConnected) {
          // If connection attempt failed, try again
          _attemptReconnect();
        } else {
          // Connection successful
          _isReconnecting = false;
          _reconnectAttempts = 0;
        }
      } catch (e) {
        print('Reconnection attempt failed: $e');
        _attemptReconnect();
      }
    });
  }

  int _calculateBackoffDelay() {
    // Exponential backoff: 2^attempt * initial delay, capped at maxReconnectDelay
    int delay = (pow(2, _reconnectAttempts - 1) * initialReconnectDelay).toInt();
    return delay.clamp(initialReconnectDelay, maxReconnectDelay);
  }

  void _startPingTimer() {
    pingTimer?.cancel();
    pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (channel != null && isConnected) {
        channel!.sink.add(jsonEncode({'type': 'ping'}));
      }
    });
  }

  void _stopPingTimer() {
    pingTimer?.cancel();
    pingTimer = null;
  }

  void sendMessage(String message) {
    if (channel != null && isConnected) {
      channel!.sink.add(message);
    }
  }

  void dispose() {
    reconnectTimer?.cancel();
    channel?.sink.close();
    channel = null;
    isConnected = false;
    _isReconnecting = false;
    _reconnectAttempts = 0;
    _stopPingTimer();
    _messageController.close();
    _connectionController.close();
  }
}