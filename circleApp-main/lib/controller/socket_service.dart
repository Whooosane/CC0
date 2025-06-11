import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class SocketService {
  late IO.Socket socket;
  void init() {
    try {
      print("Init Called");

      // Configure the socket connection
      socket = IO.io('https://cricle-app.azurewebsites.net', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'rejectUnauthorized': false,
        'extraHeaders': {'Authorization': 'Bearer $userToken}'},
      });
      print("Socket configured");

      // Connect to the server
      socket.connect();
      print("Socket connection attempted");

      // Listen for connection
      socket.onConnect((_) {
        print('Connected to Socket.IO server');
      });

      Future.delayed(Duration(seconds: 2), () {
        if (socket.connected) {
          print("Socket is connected");
        } else {
          print("Socket is not connected");
        }
      });

      // Listen for new messages
      socket.on('newMessage', (data) {
        print('New message: $data');
        // Handle the incoming message data here
      });
      print("Message listener configured");

      // Handle disconnection
      socket.onDisconnect((_) {
        print('Disconnected from Socket.IO server');
      });
      print("Disconnection handler configured");

    } catch (e) {
      print("Error Connecting: $e");
    }
  }

  void joinRoom(String circleId) {
    socket.emit('joinRoom', circleId);
  }
  void leaveRoom(String circleId) {
    socket.emit('leaveRoom', circleId);
  }
  void sendMessage(String circleId, String message) {
    socket.emit('newMessage', {'circleId': circleId, 'message': message});
  }
}