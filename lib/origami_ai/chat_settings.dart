import '../export.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../login/origami_login.dart';

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key, required this.employee});
  final Employee employee;
  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202123),
      appBar: AppBar(
        backgroundColor: Color(0xFF202123),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Settings", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.white70),
            title: Text("Account", style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: Icon(Icons.palette_outlined, color: Colors.white70),
            title: Text("Theme", style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: Icon(Icons.notifications_none, color: Colors.white70),
            title: Text("Notifications", style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.white70),
            title: Text("About", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

}
