import 'package:flutter/material.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 14, 43, 80)),
        useMaterial3: true,
      ),
      home: const ChatHomePage(),
    );
  }

}

class ChatHomePage extends StatelessWidget {
  const ChatHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'Settings') {
                // Navigate to settings page
              } else if (value == 'Profile') {
                // Navigate to profile page
              }
            },
            itemBuilder: (BuildContext context) {
              return ['Settings', 'Profile'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Number of chat items
        itemBuilder: (context, index) {
          return ChatListItem(
            username: 'User $index',
            message: 'Message $index',
            time: '10:0$index',
            unreadCount: index % 3 == 0 ? 3 : 0,
            onTap: () {
              // Navigate to chat screen
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        onPressed: () {
          // Add new chat functionality
        },
        child: const Icon(Icons.message, color: Color.fromARGB(255, 14, 43, 80),),
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String username;
  final String message;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.username,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: const Color.fromARGB(75, 14, 43, 80),
        child: Text(
          username[0],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [Expanded(
          child: Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
          const SizedBox(width: 10),
          unread_count(unreadCount),
        ]
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              message,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                time,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget unread_count(int unread) {
    if (unread > 0) {
      return CircleAvatar(
        backgroundColor: Colors.deepPurple,
        radius: 12,
        child: Text(
          unread.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    } else {
      return SizedBox(); // Return an empty SizedBox if unread is 0
    }
  }

}
