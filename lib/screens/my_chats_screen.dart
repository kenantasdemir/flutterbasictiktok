import "package:flutter/material.dart";

class MyChatsScreen extends StatefulWidget {
  const MyChatsScreen({super.key});

  @override
  State<MyChatsScreen> createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  // Dummy data for demonstration
  final List<Map<String, String>> newMatches = [
    {'name': 'Ayşe', 'avatar': 'https://randomuser.me/api/portraits/women/1.jpg'},
    {'name': 'Ömer', 'avatar': 'https://randomuser.me/api/portraits/men/2.jpg'},
    {'name': 'Zeynep', 'avatar': 'https://randomuser.me/api/portraits/women/3.jpg'},
    {'name': 'Mehmet', 'avatar': 'https://randomuser.me/api/portraits/men/4.jpg'},
    {'name': 'Fatma', 'avatar': 'https://randomuser.me/api/portraits/women/5.jpg'},
    {'name': 'Hüseyin', 'avatar': 'https://randomuser.me/api/portraits/men/6.jpg'},
  ];

  final List<Map<String, String>> conversations = [
    {'name': 'Ayşe', 'message': 'Merhaba', 'time': '10:45 AM', 'avatar': 'https://randomuser.me/api/portraits/women/1.jpg'},
    {'name': 'Ömer', 'message': 'Yarın görüşürüz', 'time': '9:30 AM', 'avatar': 'https://randomuser.me/api/portraits/men/2.jpg'},
    {'name': 'Group Chat', 'message': 'Hasan: Çok iyi', 'time': 'Dün', 'avatar': 'https://i.pravatar.cc/150?img=7'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bildirimler", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHorizontalAvatarList(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Mesajlar",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          _buildVerticalConversationList(),
        ],
      ),
    );
  }

  Widget _buildHorizontalAvatarList() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: newMatches.length,
          padding: const EdgeInsets.only(left: 16),
          itemBuilder: (context, index) {
            final match = newMatches[index];
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(match['avatar']!),
                  ),
                  const SizedBox(height: 8),
                  Text(match['name']!, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVerticalConversationList() {
    return Expanded(
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(conversation['avatar']!),
              ),
              title: Text(
                conversation['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(conversation['message']!),
              trailing: Text(conversation['time']!),
              onTap: () {
                // Navigate to chat screen
              },
            ),
          );
        },
      ),
    );
  }
}
