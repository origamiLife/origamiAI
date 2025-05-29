import '../export.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

import '../origami_ai/chat_ai.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.num,
    required this.popPage,
    this.company_id,
  });
  final int num;
  final int popPage;
  final int? company_id;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? lastPressed;
  bool isPass = true;
  bool _forgot = false;
  bool _begin = false;
  int countPage = 0;

  @override
  void initState() {
    super.initState();
    countPage = widget.num;
    print(widget.popPage);
    print(widget.company_id);
    _fetchComponent();
    loadCredentials();
    _forgotController.addListener(() {
      forgot_mail = _forgotController.text;
      print("Current text: ${_forgotController.text}");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _forgotController.dispose();
    super.dispose();
  }

  // ฟังก์ชันในการบันทึกข้อมูล
  Future<void> saveCredentials(username, password) async {
    var box = await Hive.openBox('userBox');
    // บันทึกข้อมูลลงใน Box
    await box.put('username', username);
    await box.put('password', password);
  }

  Future<void> loadCredentials() async {
    var box = await Hive.openBox('userBox');

    if (countPage == 1) {
      await box.clear();
    }

    String? username = box.get('username') ?? '';
    String? password = box.get('password') ?? '';

    setState(() {
      _usernameController.text = username ?? '';
      _passwordController.text = password ?? '';
    });

    if (username?.isNotEmpty == true && password?.isNotEmpty == true) {
      _login();
    } else {
      countPage = 1;
    }

    print('Username: $username');
  }

  Future<void> _loadBegin() async {
    await Future.delayed(Duration(seconds: 5));
    _begin = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_begin == false && _isLoading) {
      _loadBegin();
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Image.asset(
                  'assets/images/origami_ai.png', // ใส่โลโก้
                  width: MediaQuery.of(context).size.width * 0.4,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
              ),
              SizedBox(height: 16),
              Container(
                color: Colors.white,
                child: Center(
                  child: LoadingAnimationWidget.horizontalRotatingDots(
                    size: 65,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return PopScope(
        onPopInvoked: (didPop) {
          if (!didPop) {
            final now = DateTime.now();
            final maxDuration = Duration(seconds: 2);
            final isWarning = lastPressed == null ||
                now.difference(lastPressed!) > maxDuration;

            if (isWarning) {
              lastPressed = now;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Press back again to exit',
                    style: TextStyle(fontFamily: 'Arial', color: Colors.white),
                  ),
                  duration: maxDuration,
                ),
              );
            } else {
              SystemNavigator.pop();
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: backgroudComponent.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(backgroudComponent),
                      fit: BoxFit.cover,
                    )
                        : null, // หรือใช้ภาพจาก assets แทน
                  ),
                ),
                LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: _forgot
                            ? _forgotWidget(constraints)
                            : _loginWidget(constraints)),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _loginWidget(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Center(
        child: Container(
          width: constraints.maxWidth * 0.85,
          decoration: BoxDecoration(
            // color: Colors.black12,
            borderRadius: BorderRadius.circular(20),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black12,
            //     blurRadius: 10,
            //     offset: Offset(0, 4),
            //   )
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // if (isMobile)
              //   Image.network(
              //     logoComponent, // ใส่โลโก้
              //     width: 300,
              //     fit: BoxFit.contain,
              //     errorBuilder: (context, error, stackTrace) {
              //       return Container(
              //         color: Colors.transparent,
              //         child: Center(
              //           child: LoadingAnimationWidget.horizontalRotatingDots(
              //             size: 65,
              //             color: Colors.orange,
              //           ),
              //         ),
              //       );
              //     },
              //   )
              // else
              //   Image.network(
              //     logoComponent, // ใส่โลโก้
              //     width: 400,
              //     fit: BoxFit.contain,
              //     errorBuilder: (context, error, stackTrace) {
              //       return Container(
              //         color: Colors.transparent,
              //         child: Center(
              //           child: LoadingAnimationWidget.horizontalRotatingDots(
              //             size: 65,
              //             color: Colors.orange,
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // if (isMobile)
              Image.asset(
                'assets/images/origami_ai.png', // ใส่โลโก้
                width: 500,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.transparent,
                    child: Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 65,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
              // Text(
              //   titleComponent,
              //   style: const TextStyle(
              //     fontFamily: 'Arial',
              //     color: Colors.white,
              //     fontWeight: FontWeight.w500,
              //     fontSize: 40,
              //   ),
              // ),
              // if (isMobile)
              //   Text(
              //     'ACADEMY',
              //     style: TextStyle(
              //       fontFamily: 'Arial',
              //       color: Colors.white,
              //       fontWeight: FontWeight.w700,
              //       fontSize: isMobile ? 70 : 100,
              //     ),
              //   )
              SizedBox(height: constraints.maxWidth * 0.05),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                        _usernameController, 'Username', Icons.person),
                    const SizedBox(height: 18),
                    _buildPasswordField(),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _onForgotPasswordPressed,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_open,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Forgot Pwd?',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLoginButton(),
                    const SizedBox(height: 30), // ป้องกันปุ่มล้นขอบล่าง
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onForgotPasswordPressed() {
    setState(() => _forgot = true);
  }

  Widget _forgotWidget(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Center(
        child: Container(
          width: constraints.maxWidth * 0.85,
          decoration: BoxDecoration(
            // color: Colors.black12,
            borderRadius: BorderRadius.circular(20),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black12,
            //     blurRadius: 10,
            //     offset: Offset(0, 4),
            //   )
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/origami_ai.png', // ใส่โลโก้
                width: constraints.maxWidth * 0.9,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.transparent,
                    child: Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 65,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'Forgot your password?',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '    Please enter your email address to request a password reset.',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.orange.shade50,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _forgotController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9@#%&*_!$^(),.?":;{}|<>-]')),
                      ],
                      style: TextStyle(
                          fontFamily: 'Arial', color: Color(0xFF555555)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            fontFamily: 'Arial', color: Color(0xFF555555)),
                        prefixIcon: Icon(Icons.email, color: Color(0xFF555555)),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(1),
                          foregroundColor: Colors.red,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _fetchForgetMail(),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 60, right: 60, bottom: 12, top: 12),
                          child: Text(
                            'SEND',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _forgot = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.chevron_left,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Return to login.',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon) {
    return TextFormField(
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9@#%&*_!$^(),.?":;{}|<>-]')),
      ],
      style: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
        prefixIcon: Icon(icon, color: Color(0xFF555555)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: isPass,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9@#%&*_!$^(),.?":;{}|<>-]')),
      ],
      style: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Password',
        hintStyle: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
        prefixIcon: Icon(Icons.lock, color: Color(0xFF555555)),
        suffixIcon: IconButton(
          onPressed: () => setState(() => isPass = !isPass),
          icon: Icon(
              isPass ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
          color: Color(0xFF555555),
          iconSize: 18,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: Colors.red,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _login,
        child: Text(
          'LOGIN',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(List<Employee> employee, String username) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(18), // ขยายเต็มจอ
            child: GridView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: employee.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 รูปต่อแถว
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1, // อัตราส่วนกว้าง/สูง (ปรับได้ตามต้องการ)
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () async {
                        await Future.delayed(Duration(seconds: 1));
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => AcademyHomePage(
                        //       employee: employee[index],
                        //       Authorization: authorization,
                        //       learnin_page: 'course',
                        //       logo: logoComponent,
                        //       company_id: index,
                        //     ),
                        //   ),
                        // );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatOrigamiAi(
                              employee: employee[index],
                              logo: logoComponent,
                              company_id: index,
                              gmail: username, groupid: '',
                            ),
                          ),
                        );
                        // Navigator.pop(context); // ปิด Dialog เมื่อแตะที่รูป
                      },
                      child: Card(
                        child: Image.network(
                          employee[index].comp_logo,
                          fit: BoxFit.contain,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error);
                          },
                        ),
                      ));
                }));
      },
    );
  }

  Future<void> _login() async {
    // _loadSelectedRadio();
    String username = _usernameController.text;
    String password = _passwordController.text;
    // _saveCredentials(username, password);
    saveCredentials(username, password);
    if (username.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password.',
              style: const TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              )),
        ),
      );
      return;
    } else if (username.isNotEmpty && password.isNotEmpty) {
      _fetchLogin(username, password);
    }
  }

  Future<void> _fetchLogin(String username, String password) async {
    final uri = Uri.parse('$host/api/origami/signin.php');
    final response = await http.post(
      uri,
      body: {
        // 'username': 'chakrit@trandar.com',
        // 'password': '@HengL!ke08'
        'auth_password': 'ori20#17gami',
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 200) {
        final List employeeJson = jsonResponse['employee_data'];
        List<Employee> employee = [];
        setState(() {
          employee =
              employeeJson.map((json) => Employee.fromJson(json)).toList();
          _isLoading = true;
        });
        if (countPage == 1) {
          if (employee.length <= 1) {
            pushPage(employee, widget.company_id ?? 0, username);
          } else {
            _showFullScreenImage(employee, username);
          }
        } else {
          await Future.delayed(const Duration(seconds: 1));
          pushPage(employee, widget.company_id ?? 0, username);
        }
      } else {
        final String error_message = jsonResponse['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error_message, // 'Email or Password is incorrect, please try again',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status Code Error!',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              )),
        ),
      );
    }
  }

  void pushPage(List<Employee> employee, int index, String username) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatOrigamiAi(
          employee: employee[widget.company_id ?? 0],
          logo: logoComponent,
          company_id: widget.company_id ?? 0,
          gmail: username, groupid: '',
        ),
      ),
    );
  }

  String forgot_mail = '';
  Future<void> _fetchForgetMail() async {
    final uri = Uri.parse("$host/api/origami/forgot_password.php");
    final response = await http.post(
      uri,
      body: {
        'email': forgot_mail,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == false) {
        final message = jsonResponse['message'];
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
      }
    } else {
      throw Exception('Failed to load projects');
    }
  }

  String logoComponent = '';
  String titleComponent = '';
  String backgroudComponent = '';
  Future<void> _fetchComponent() async {
    final uri = Uri.parse("$host/api/origami/e-learning/component.php");
    final response = await http.post(
      uri,
      body: {
        'auth_password': authorization,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 200) {
        setState(() {
          logoComponent = jsonResponse['logo'];
          titleComponent = jsonResponse['title'];
          backgroudComponent = jsonResponse['backgroud'];
        });
      } else {
        final message = jsonResponse['message'];
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
      }
    } else {
      throw Exception('Failed to load projects');
    }
  }
}

class Employee {
  final String emp_id;
  final String emp_code;
  final String emp_name;
  final String emp_avatar;
  final String comp_id;
  final String comp_name;
  final String comp_logo;
  final String dept_name;
  final String dna_color;
  final String password_verify;
  final String endpoint;

  const Employee({
    required this.emp_id,
    required this.emp_code,
    required this.emp_name, // ชื่อ
    required this.emp_avatar, // รูปภาพ
    required this.comp_id,
    required this.comp_name,
    required this.comp_logo,
    required this.dept_name,
    required this.dna_color,
    required this.password_verify,
    required this.endpoint,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      emp_name: json['emp_name'] ?? '',
      emp_avatar: json['emp_avatar'] ?? '',
      comp_id: json['comp_id'] ?? '',
      comp_name: json['comp_name'] ?? '',
      comp_logo: json['comp_logo'] ?? '',
      dept_name: json['dept_name'] ?? '',
      dna_color: json['dna_color'] ?? '',
      password_verify: json['password_verify'] ?? '',
      endpoint: json['endpoint'] ?? '',
    );
  }
}