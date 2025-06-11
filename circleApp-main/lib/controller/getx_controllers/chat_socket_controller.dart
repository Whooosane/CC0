import 'dart:developer';
import 'package:circleapp/controller/utils/api_constants.dart';
import 'package:circleapp/models/message_models/get_message_model.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
bool isMainChat = true;

class ChatSocketService extends GetxController {
  IO.Socket? socket;
  List<Map<String, dynamic>> pendingMessages = []; // Store messages that failed to send
  // Initialize the connection and authenticate using a JWT token
  void connect(String token) {
    if (socket == null || !socket!.connected) {
      socket = IO.io(
        baseURL,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])  // Enable fallback to polling
            .setExtraHeaders({'Authorization': 'Bearer $token'})  // Authorization header
            .setReconnectionAttempts(5)  // Attempt to reconnect 5 times
            .setReconnectionDelay(1000)  // Delay between reconnection attempts (in ms)
            .build(),
      );

      // Handle connection
      socket!.onConnect((_) {
        log('Connected to the server');
      });

      // Handle errors
      socket!.on('connect_error', (error) {
        log('Connection error: $error');
      });

      socket!.on('disconnect', (_) {
        log('Disconnected from the server $_');
      });

    } else {
      log('Socket is already connected');
    }
  }

  // Emit "chatScreenOpen" when the chat list screen is opened
  void emitChatScreenOpen() {
    if (socket != null && socket!.connected) {
      socket!.emit('chatScreenOpen');
      log('Emitted chatScreenOpen');
    }
  }

  // Emit "chatScreenClose" when the chat list screen is closed
  void emitChatScreenClose() {
    if (socket != null && socket!.connected) {
      socket!.emit('chatScreenClose');
      log('Emitted chatScreenClose');
    }
  }

  // Emit "joinRoom" when entering the chat details screen
  void joinRoom(String circleId) {
    if (socket != null && socket!.connected) {
      socket!.emit('joinRoom', circleId);
      log('Joined room: $circleId');
    } else {
      log('Socket not connected');
    }
  }

  // Leave room when leaving the chat details screen
  void leaveRoom(String circleId) {
    if (socket != null && socket!.connected) {
      socket!.emit('leaveRoom', circleId);
      log('Left room: $circleId');
    } else {
      log('Socket not connected');
    }
  }

  // Send message
  void sendMessage(String circleId, MessageData message) {
    if (socket != null && socket!.connected) {
      // Emit the entire Message instance converted to a Map
      socket!.emit('sendMessage', {
        'circleId': circleId,
        'message': message.toJson(),
      });
      log('Sent message to $circleId: ${message.text}');
    } else {
      log('Socket not connected. Storing message for retry.');
      pendingMessages.add({
        'circleId': circleId,
        'message': message.toJson(),
      }); // Store the entire message as JSON for retry
    }
  }

  // Listen for new messages on the list screen
  void listenForNewMessagesInList(Function(String circleId, MessageData message) callback) {
    if (socket != null && isMainChat) {
      socket!.on('sendMessage', (data) {
        String circleId = data['circleId'];
        MessageData message = MessageData.fromJson(data['message']);
        callback(circleId, message);
        log('Received message in list screen: ${message.text}');
      });
    } else {
      log('Socket not connected');
    }
  }

  // Listen for new messages on the chat details screen
  void listenForNewMessagesInChat(Function(String circleId, MessageData message) callback) {
    if (socket != null && !isMainChat) {
      socket!.on('sendMessage', (data) {
        String circleId = data['circleId'];
        MessageData message = MessageData.fromJson(data['message']);
        callback(circleId, message);
        log('Received message in chat screen: ${message.text}');
      });
    } else {
      log('Socket not connected');
    }
  }

  void removeMessageListeners() {
    if (socket != null) {
        socket!.off('sendMessage'); // Remove listener for list screen
        log('Removed sendMessage listener from list screen');
    }
  }

  // Disconnect socket
  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      log('Socket disconnected');
    }
  }
}
