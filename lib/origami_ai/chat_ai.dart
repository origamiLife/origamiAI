import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import '../export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../login/origami_login.dart';
import '../main.dart';
import 'chat_settings.dart';
import 'package:flutter/gestures.dart';

class ChatOrigamiAi extends StatefulWidget {
  ChatOrigamiAi({
    Key? key,
    required this.employee,
    required this.logo,
    this.company_id,
    required this.gmail,
    required this.groupid,
  }) : super(key: key);
  final Employee employee;
  final String logo;
  final int? company_id;
  final String gmail;
  final String groupid;

  @override
  State<ChatOrigamiAi> createState() => _ChatOrigamiAiState();
}

class _ChatOrigamiAiState extends State<ChatOrigamiAi> {
  TextEditingController _messageController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    if (widget.groupid == '') {
      _fetchGroupId();
    } else {
      fetchInchatHistotyChat(widget.groupid);
    }
  }

  void _handleSend(String input) {
    final time = DateFormat('HH:mm:ss').format(DateTime.now());
    if (input.trim().isEmpty) return;
    fetchLiveChat(input, time);
    _messageController.clear();
  }

  String _getBotReply(String input) {
    input = input.toLowerCase();
    if (input.contains(input)) {
      return replyMessage;
    }
    return "ขออภัย ผมยังไม่เข้าใจคำถามนี้ 😅";
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: _chatOrigami(),
    );
  }

  String dataMessage = '';
  Widget _chatOrigami() {
    return SafeArea(
      child: Column(
        children: [
          _buildNavigationBar(),
          Flexible(
            child: live_message == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_ChatOrigamiAi()],
                  )
                : _ChatOrigamiAi2(),
          ),
          Divider(),
          _buildNavigationBottonBar(),
        ],
      ),
    );
  }

  // chatModel
  Widget _ChatOrigamiAi() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '👋 Hello from Origami AI',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 24,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ChatOrigamiAi2() {
    final now = new DateTime.now();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(right: 8, left: 8, top: 16, bottom: 16),
        child: Row(
          children: [
            // new chat
            Expanded(child: _isUserAndAdmin())
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // สีเงา
            spreadRadius: 0,
            blurRadius: 8, // ความฟุ้งของเงา
            offset: Offset(0, 5), // การเยื้องของเงา (แนวแกน X, Y)
          ),
          BoxShadow(
            color: Colors.orange.withOpacity(0.8),
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          icon: Icon(Icons.menu, color: Colors.black, size: 28),
                        ),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ORIGAMI AI',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 28,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'What can I help with?',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CircleAvatar(
                radius: 31,
                backgroundColor: Colors.grey.shade300,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Image.network(
                        widget.employee.comp_logo, //widget.logo,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://dev.origami.life/uploads/employee/20140715173028man20key.png', // A default placeholder image in case of an error
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBottonBar() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
            child: TextFormField(
              controller: _messageController,
              keyboardType: TextInputType.text,
              onFieldSubmitted: _handleSend,
              style: TextStyle(
                fontFamily: 'Arial',
                color: Color(0xFF555555),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                hintText: 'Write a message...',
                hintStyle: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // prefixIcon: Icon(
                //   FontAwesomeIcons.solidPaperPlane,
                //   color: Colors.transparent,
                // ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange, // ขอบสีส้มตอนที่โฟกัส
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 2, right: 18),
          child: InkWell(
            onTap: () {
              _handleSend(_messageController.text);
            },
            child: Icon(
              FontAwesomeIcons.solidPaperPlane,
              color: Color(0xFFFF9900),
              size: 20,
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(right: 8),
        //   child: InkWell(
        //     onTap: () {
        //       // pickFile();
        //     },
        //     child: Icon(
        //       FontAwesomeIcons.paperclip,
        //       color: Colors.orange,
        //       // size: 24,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF202123),
      child: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatOrigamiAi(
                      employee: widget.employee,
                      logo: widget.logo,
                      company_id: widget.company_id,
                      gmail: widget.gmail,
                      groupid: '',
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "New Chat",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.edit_note,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.white24),
            Expanded(
              child: ListView(
                children: [
                  Container(
                      child: _drawerItemHistory(
                          Icons.history, "Previous Chats", 0)),
                ],
              ),
            ),
            Divider(color: Colors.white24),
            _drawerItem(Icons.security, "Security", 1),
            _drawerItem(Icons.help_outline, "Help & FAQ", 2),
            ListTile(
              leading: CachedNetworkImage(
                imageUrl: widget.employee.emp_avatar,
                imageBuilder: (context, imageProvider) =>
                    CircleAvatar(backgroundImage: imageProvider),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
                  ),
                ),
              ),
              title: Text(
                widget.employee.emp_name,
                style: TextStyle(
                  // fontFamily: 'Arial',
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                widget.employee.comp_name,
                style: TextStyle(
                  fontFamily: 'Arial',
                  // fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(Icons.logout, color: Colors.white70),
              onTap: () => fetchLogout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItemHistory(IconData icon, String title, int screen) {
    return FutureBuilder<List<HistotyMessage>>(
      future: fetchHistotyMessage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            leading: Icon(Icons.error, color: Colors.red),
            title: Text(
              'Error loading history',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return ListTile(
            leading: Icon(Icons.history, color: Colors.white70),
            title: Text(
              "No chat history",
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white70),
                    SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              ...?snapshot.data?.map((chat) {
                return ListTile(
                  leading: Icon(Icons.chat, color: Colors.white60),
                  title: Text(
                    chat.subject,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatOrigamiAi(
                          employee: widget.employee,
                          logo: widget.logo,
                          company_id: widget.company_id,
                          gmail: widget.gmail,
                          groupid: chat.group_id,
                        ),
                      ),
                    );
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('Opened: ${chat.a_message}')),
                    // );
                    // TODO: Navigate to chat detail screen
                  },
                );
              }).toList(),
            ],
          );
        }
      },
    );
  }

  Widget _drawerItem(IconData icon, String title, int screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () {
        // Navigator.pop(context);
        if (screen == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatSecurityScreen(
                  employee: widget.employee,
                ),
              ));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Tapped: $title')));
        }
      },
    );
  }

  Widget _isUserAndAdmin() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _messages.length,
            itemBuilder: (_, index) {
              final msg = _messages[index];
              final isLast = index == _messages.length - 1;
              if (msg.isUser) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: _isChatIsload(msg, isLast)),
                      const SizedBox(width: 8),
                      _buildAvatarR(widget.employee.emp_avatar),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAvatarL('assets/images/ai-logo.png'),
                      const SizedBox(width: 8),
                      Flexible(child: _isChat(msg)),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarR(String imageUrl) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.orange.shade400,
      child: CircleAvatar(
        radius: 21,
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
                fit: BoxFit.contain,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarL(String imageUrl) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.orange.shade400,
      child: CircleAvatar(
        radius: 21,
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                'https://dev.origami.life/uploads/employee/20140715173028man20key.png',
                fit: BoxFit.contain,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _isChatIsload(ChatMessage msg, bool isLastMessage) {
    if (isLastMessage) {
      // กำลังโหลด และเป็นข้อความสุดท้าย => แสดง shimmer
      return Column(
        crossAxisAlignment:
            msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: _isChat(msg),
          ), // ข้อความฝั่งขวา (ของผู้ใช้)

          SizedBox(height: 8),

          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                _buildAvatarL('assets/images/ai-logo.png'),
                const SizedBox(width: 8),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // ข้อความอื่น แสดงปกติ
      return _isChat(msg);
    }
  }

  // chatModel
  Widget _isChat(ChatMessage msg) {
    String fullMessage = msg.text + (msg.url != "" ? ' ${msg.url}' : '');
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color:
                    msg.isUser ? Colors.orange.shade400 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: msg.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // AnimatedTextKit(
                  //     animatedTexts: [
                  //       TyperAnimatedText(
                  //         msg.text,
                  //         textStyle: const TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //         speed: const Duration(milliseconds: 10),
                  //       ),
                  //     ],
                  //
                  //     totalRepeatCount: 1,
                  //     pause: const Duration(milliseconds: 20),
                  //     displayFullTextOnTap: false,
                  //     stopPauseOnTap: false,
                  //     isRepeatingAnimation:false,
                  //     repeatForever:false,
                  //     // controller: myAnimatedTextController
                  // ),

                  SelectableText.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: msg.isUser ? Colors.white : Color(0xFF555555),
                      ),
                      children: [
                        TextSpan(text: msg.text),
                        if (msg.url != "") ...[
                          TextSpan(
                            text: ' ${msg.url}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline, //การขีกเส้น
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(Uri.parse(msg.url));
                              },
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!msg.isUser)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.share, size: 18),
                              color: Colors.black54,
                              onPressed: () {
                                Share.share(fullMessage);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.copy, size: 18),
                              color: Colors.black54,
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: fullMessage));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('คัดลอกข้อความแล้ว')),
                                );
                              },
                            ),
                          ],
                        )
                      else
                        SizedBox(width: 36),
                      Flexible(
                        child: Text(
                          msg.time.isNotEmpty
                              ? msg.time
                              : DateFormat('HH:mm:ss').format(DateTime.now()),
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12,
                            color:
                                msg.isUser ? Colors.white : Color(0xFF555555),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool live_message = false; // เมื่อเป็นค่าว่า
  String replyMessage = '';
  // แชทด้านใน
  Future<void> fetchLiveChat(String message, String time) async {
    print('แชทด้านใน');
    try {
      live_message = true;
      setState(() {
        _messages
            .add(ChatMessage(text: message, url: '', isUser: true, time: time));
      });
      print(
          'Chat : \ngroup_id : ${groupIntId.toString()} \nemp_message : ${message}');
      final response = await http.post(
        Uri.parse('$hostDev/api/origami/ai/live_chat.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'auth_password': authorization,
          'emp_message': message,
          'group_id': groupIntId.toString(),
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          // final group_id = jsonResponse['group_id'] ?? '';
          final reply = jsonResponse['reply'] ?? '';
          replyMessage = reply.replaceAll(RegExp(r'<br\s*/?>'), '');
          final urlMessage = jsonResponse['url'] ?? '';
          setState(() {
            _messages.add(
              ChatMessage(
                text: _getBotReply(message),
                url: urlMessage,
                isUser: false,
                time: time,
              ),
            );
          });
        } else {
          replyMessage = "ขออภัย ผมยังไม่เข้าใจคำถามนี้ 😅";
          setState(() {
            _messages.add(
              ChatMessage(
                  text: _getBotReply(message),
                  url: '',
                  isUser: false,
                  time: ''),
            );
          });
        }
      } else {
        throw Exception(
          'Failed to load personal data: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      setState(() {
        replyMessage = 'เกิดข้อผิดพลาดแชท: $e';
      });
    }
  }

  int groupIntId = 0;
  Future<void> _fetchGroupId() async {
    print('group Id');
    final response = await http.post(
      Uri.parse("$hostDev/api/origami/ai/live_create_chat.php"),
      body: {
        'comp_id': widget.employee.comp_id,
        'emp_id': widget.employee.emp_id,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        groupIntId = jsonResponse['group_id'] ?? 0;
      }
    } else {
      throw Exception('Failed to load projects');
    }
  }

  int pages = 0;
  bool nextpage = false;
  bool isMessage = false;
  bool isChatModel = false;
  List<InchatChatHistoty> chatModel = [];
  // ประวัติด้านใน
  Future<void> fetchInchatHistotyChat(String group_id) async {
    print('ดึงประวัติการแชท... $group_id');
    try {
      final response = await http.post(
        Uri.parse('$hostDev/api/origami/ai/live_inchat_history.php'),
        headers: {'Authorization': 'Bearer $authorization'},
        body: {
          'emp_id': widget.employee.emp_id,
          'comp_id': widget.employee.comp_id,
          'group_id': group_id,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        final String groupIdStr = jsonResponse['group_id'] ?? '0';

        setState(() {
          _messages = data.map((item) {
            return ChatMessage(
              text: item['message'] ?? '',
              isUser: item['key'] == 'R',
              url: '', // ถ้ามี url จริง ให้ใส่จาก item['url']
              time: item['date_created'].substring(11) ?? '', // ใช้เวลาแสดงได้
            );
          }).toList();

          groupIntId = int.parse(groupIdStr);
          live_message = true;
          isMessage = true;
          isChatModel = true;
        });
      } else {
        throw Exception(
          'โหลดประวัติไม่สำเร็จ: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('เกิดข้อผิดพลาดประวัติ: $e');
    }
  }

  // ประวัติด้านข้าง
  Future<List<HistotyMessage>> fetchHistotyMessage() async {
    print(
        'ประวัติด้านข้าง ${widget.employee.emp_id} ${widget.employee.comp_id}');
    final response = await http.post(
      Uri.parse('$hostDev/api/origami/ai/live_chat_history.php'),
      headers: {'Authorization': 'Bearer $authorization'},
      body: {
        'emp_id': widget.employee.emp_id,
        'comp_id': widget.employee.comp_id,
        'page': pages.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> dataJson = jsonResponse['data_history'] ?? [];
      return dataJson.map((json) => HistotyMessage.fromJson(json)).toList();
    } else {
      print("['next_page']");
      throw Exception(
        'Failed to load question data, status code: ${response.statusCode}',
      );
    }
  }

  Future<void> fetchLogout() async {
    try {
      final response = await http.post(
        Uri.parse('$host/api/origami/signout.php'),
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'auth_password': authorization,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LoginPage(num: 1, popPage: 0, company_id: 0),
            ),
            (route) => false,
          );
          print("logout message: ${jsonResponse['status']}");
        } else {
          throw Exception(
            'Failed to load personal data: ${jsonResponse['message']}',
          );
        }
      } else {
        throw Exception(
          'Failed to load personal data: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load personal data: $e');
    }
  }
}

class ChataiModel {
  String id;
  String name;
  ChataiModel({required this.id, required this.name});
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String url;
  final String time;

  ChatMessage(
      {required this.text,
      required this.url,
      required this.isUser,
      required this.time});
}

class HistotyMessage {
  final String group_id;
  final String subject;
  final String date_created;

  HistotyMessage({
    required this.group_id,
    required this.subject,
    required this.date_created,
  });

  factory HistotyMessage.fromJson(Map<String, dynamic> json) {
    return HistotyMessage(
      group_id: json['group_id'] ?? '',
      subject: json['subject'] ?? '',
      date_created: json['date_created'] ?? '',
    );
  }
}

class InchatChatHistoty {
  final String key;
  final String message;
  final String date_created;

  InchatChatHistoty({
    required this.key,
    required this.message,
    required this.date_created,
  });

  factory InchatChatHistoty.fromJson(Map<String, dynamic> json) {
    return InchatChatHistoty(
      key: json['key'] ?? '',
      message: json['message'] ?? '',
      date_created: json['date_created'] ?? '',
    );
  }
}
