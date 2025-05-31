import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whazlansaja/models/dosen_model.dart';
import 'package:whazlansaja/screen/pesan_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  List<DosenModel> listDosen = [];

  @override
  void initState() {
    super.initState();
    loadDosenJson();
  }

  Future<void> loadDosenJson() async {
    final String response = await rootBundle.loadString('assets/json_data_chat_dosen/dosen_chat.json');
    final data = json.decode(response) as List;
    setState(() {
      listDosen = data.map((e) => DosenModel.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhArifin'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_enhance)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: listDosen.length + 1, // +1 untuk search bar
        itemBuilder: (context, index) {
          if (index == 0) {
            // Search Bar di paling atas
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: SearchAnchor.bar(
                barElevation: const WidgetStatePropertyAll(2),
                barHintText: 'Cari dosen dan mulai chat',
                suggestionsBuilder: (context, controller) {
                  return <Widget>[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Belum ada pencarian'),
                      ),
                    ),
                  ];
                },
              ),
            );
          }

          final dosen = listDosen[index - 1];
          final lastMessage = dosen.messages.isNotEmpty
              ? dosen.messages.last.message
              : 'Belum ada pesan';

          int unreadCount = dosen.messages
              .where((msg) => !msg.isRead && msg.from == 0)
              .length;

          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PesanScreen(dosen: dosen),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: AssetImage(dosen.avatar),
            ),
            title: Text(
              dosen.fullName,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              lastMessage,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (dosen.fullName == 'Azlan, S.Kom., M.Kom.' && unreadCount > 0)
                  Transform.translate(
                    offset: const Offset(24, 0),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  dosen.fullName == 'Azlan, S.Kom., M.Kom.' ? '2 menit lalu' : 'kemarin',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Pembaruan'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Komunitas'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Panggilan'),
        ],
      ),
    );
  }
}
