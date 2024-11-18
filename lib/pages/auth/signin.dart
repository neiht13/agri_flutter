// lib/pages/signin_page.dart
import 'package:agriplant/api_service.dart';
import 'package:agriplant/widgets/custom_icon.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_btn.dart';
import '../../widgets/input_field.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  // Controllers cho các ô nhập liệu
  final TextEditingController _usernameController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  // Khóa cho Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Các biến trạng thái
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;
  bool _isPasswordVisible = false; // Để toggle hiển thị mật khẩu

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Phương thức xử lý đăng nhập
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      // Nếu form không hợp lệ, không làm gì cả
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = ApiService();
      final token = await apiService.login(username, password);
      if (token != null) {
        // Nếu "Remember Me" được chọn, lưu token vào SharedPreferences
        if (_rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
        }

        // Chuyển đến MainPage
        context.go("/farmlogs");
        showCustomSnackBar(context, "Đăng nhập thành công",
            type: "success", icon: FontAwesomeIcons.infoCircle);
      } else {
        setState(() {
          _errorMessage =
              "Thông tin đăng nhập không chính xác. Vui lòng thử lại.";
        });

        showCustomSnackBar(
            context,
            "Thông tin đăng nhập không chính xác. Vui lòng thử lại.",
            type: "error",
            icon: FontAwesomeIcons.triangleExclamation);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
      showCustomSnackBar(context, _errorMessage!,
          type: "error", icon: FontAwesomeIcons.triangleExclamation);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Hàm để hiển thị SnackBar tùy chỉnh
  void showCustomSnackBar(BuildContext context, String message,
      {required String type, required IconData icon}) {
    Color backgroundColor;
    IconData? snackIcon;

    switch (type) {
      case "success":
        backgroundColor = Colors.green;
        snackIcon = FontAwesomeIcons.checkCircle;
        break;
      case "error":
        backgroundColor = Colors.red;
        snackIcon = FontAwesomeIcons.triangleExclamation;
        break;
      default:
        backgroundColor = Colors.blue;
        snackIcon = FontAwesomeIcons.infoCircle;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            FaIcon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Đăng ký khóa cho Form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/login.png", width: 400,),
                const SizedBox(height: 50),
                // Ô nhập tên đăng nhập
                FadeInLeft(
                  child: InputField(
                    hintText: "Nhập tên đăng nhập",
                    labelText: "Tên đăng nhập",
                    controller: _usernameController,
                    prefixIcon: const CustomIcon(IconlyBroken.user2),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên đăng nhập.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Ô nhập mật khẩu
                FadeInRight(
                  child: InputField(
                    hintText: "Nhập mật khẩu",
                    labelText: "Mật khẩu",
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    prefixIcon: const CustomIcon(IconlyBroken.password),
                    suffixIcon: IconButton(
                      icon: CustomIcon(
                        _isPasswordVisible
                            ? IconlyBroken.show
                            : IconlyBroken.hide,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu.';
                      } else if (value.length < 6) {
                        return 'Mật khẩu phải ít nhất 6 ký tự.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Hàng chứa checkbox "Ghi nhớ tôi" và "Quên mật khẩu?"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CupertinoCheckbox(
                          value: _rememberMe,
                          checkColor: Colors.white,
                          activeColor:
                              Theme.of(context).colorScheme.primary,
                          onChanged: (val) {
                            setState(() {
                              _rememberMe = val ?? false;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _rememberMe = !_rememberMe;
                            });
                          },
                          child: Text(
                            "Ghi nhớ tôi",
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        // Thực hiện chức năng Quên mật khẩu nếu cần
                        // Ví dụ: chuyển đến trang Quên mật khẩu
                      },
                      child: Text(
                        "Quên mật khẩu?",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Nút đăng nhập hoặc hiển thị loading
                _isLoading
                    ? const CircularProgressIndicator()
                    : FadeInUp(
                        duration: _errorMessage != null
                            ? const Duration(milliseconds: 0)
                            : const Duration(milliseconds: 555),
                        child: CustomBtn(
                          icon: IconlyBroken.login,
                          text: "Đăng nhập",
                          onPressed: _handleLogin,
                        ),
                      ),
                // Liên kết đến trang đăng ký
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text.rich(
                    TextSpan(
                      text: "Chưa có tài khoản? ",
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "Đăng ký",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push("/signup");
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
