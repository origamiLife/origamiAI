import '../export.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../login/origami_login.dart';
import '../main.dart';

class ChatSecurityScreen extends StatefulWidget {
  const ChatSecurityScreen({super.key, required this.employee});
  final Employee employee;
  @override
  State<ChatSecurityScreen> createState() => _ChatSecurityScreenState();
}

class _ChatSecurityScreenState extends State<ChatSecurityScreen>
    with WidgetsBindingObserver {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  bool _showOld = false;
  bool _showNew = true;
  bool _showConfirm = true;

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(() {
      setState(() {
        _oldPassword = _oldPasswordController.text;
      });
    });
    _newPasswordController.addListener(() {
      setState(() {
        _newPassword = _newPasswordController.text;
      });
    });
    _confirmPasswordController.addListener(() {
      setState(() {
        _confirmPassword = _confirmPasswordController.text;
      });
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202123),
      appBar: AppBar(
        backgroundColor: Color(0xFF202123),
        iconTheme: IconThemeData(color: Colors.white),
        // title: Text("Settings", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "   Choose a strong password and don't reuse it for other accounts.",
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 16),
                        _TextFormField(
                            'Old password', _showOld, _oldPasswordController),
                        SizedBox(height: 16),
                        _TextFormField(
                            'New password', _showNew, _newPasswordController),
                        _Condition(_hasMin, 'At least 8 characters long'),
                        _Condition(_hasUpper,
                            'At least one uppercase English letter'),
                        _Condition(_hasLower,
                            'At least one lowercase English letter'),
                        _Condition(
                            _hasSpecial, 'At least 1 special character'),
                        SizedBox(height: 8),
                        _TextFormField('Confirm password', _showConfirm,
                            _confirmPasswordController),
                        SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFFF9900),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (isValid && _oldPassword == _newPassword ||
                      _oldPassword == _confirmPassword) {
                    showDialog(
                      context: context, // Assuming context is available
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Invalid Password"),
                          content: Text(
                              "The new password must be different from your old password. Please enter the new password again."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'The new password must be different from your old password. Please enter the new password again.',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    );
                  } else if (isValid && _newPassword == _confirmPassword) {
                    _fetchChangePassword();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'SAVE',
                      style: TextStyle(fontFamily: 'Arial', fontSize: 18),
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

  Widget _TextFormField(String title, bool showPass, controller) {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: controller,
        obscureText: showPass,
        style: TextStyle(
          fontFamily: 'Arial',
          color: Color(0xFF555555),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          hintText: title,
          hintStyle: TextStyle(
            fontFamily: 'Arial',
            color: Color(0xFF555555),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Color(0xFF555555),
            size: 18,
          ),
          // suffixIcon: IconButton(
          //   icon: Icon(
          //     showPass ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
          //     color: Color(0xFF555555),
          //     size: 18,
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       showPass = !showPass;
          //     });
          //   },
          // ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF9900), width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFFFF9900), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF9900), width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF9900), width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _Condition(bool isTrue, String title) {
    return Container(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            (isTrue)
                ? Icon(Icons.check_circle_rounded, color: Colors.green)
                : Icon(
                    Icons.circle_outlined,
                    color: Colors.white70,
                  ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValid = false;

  void _validatePassword(String text) {
    setState(() {
      _hasMin = _hasMinLength(text);
      _hasUpper = _hasUpperCase(text);
      _hasLower = _hasLowerCase(text);
      _hasSpecial = _hasSpecialCharacter(text);
      isValid = _hasMinLength(text) &&
          _hasUpperCase(text) &&
          _hasLowerCase(text) &&
          _hasSpecialCharacter(text);
    });
  }

  bool _hasMin = false;
  bool _hasUpper = false;
  bool _hasLower = false;
  bool _hasSpecial = false;
  bool _hasMinLength(String text) => text.length >= 8;
  bool _hasUpperCase(String text) => text.contains(RegExp(r'[A-Z]'));
  bool _hasLowerCase(String text) => text.contains(RegExp(r'[a-z]'));
  bool _hasSpecialCharacter(String text) =>
      text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  Future<void> _fetchChangePassword() async {
    final uri = Uri.parse("$host/api/origami/change_password.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $authorization'},
      body: {
        'emp_id': widget.employee.emp_id,
        'comp_id': widget.employee.comp_id,
        'password': _newPassword,
        'password_ex': _oldPassword,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == false) {
        final message = jsonResponse['message'];
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(num: 1, popPage: 0, company_id: 0),
          ),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        _hasMin = false;
        _hasUpper = false;
        _hasLower = false;
        _hasSpecial = false;
      }
    } else {
      throw Exception('Failed to load projects');
    }
  }
}
