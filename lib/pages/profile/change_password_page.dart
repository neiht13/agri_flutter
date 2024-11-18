// lib/presentation/screen/change_password/change_password_page.dart
import 'package:agriplant/utils/contants.dart';
import 'package:agriplant/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    const success = true;

    setState(() {
      isLoading = false;
    });

    if (success) {
      showCustomSnackBar(context, "Thay đổi mật khẩu thành công", type: "success");
      context.pop();
    } else {
      showCustomSnackBar(context, "Mật khẩu hiện tại không chính xác", type: "error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thay đổi mật khẩu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    InputField(
                      controller: currentPasswordController,
                      labelText: "Mật khẩu hiện tại",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu hiện tại';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      controller: newPasswordController,
                      labelText: "Mật khẩu mới",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu mới';
                        }
                        if (value.length < 6) {
                          return 'Mật khẩu mới phải có ít nhất 6 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      controller: confirmPasswordController,
                      labelText: "Xác nhận mật khẩu mới",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng xác nhận mật khẩu mới';
                        }
                        if (value != newPasswordController.text) {
                          return 'Mật khẩu xác nhận không trùng khớp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    FilledButton(
                      onPressed: _changePassword,
                      child: const Text("Lưu thay đổi"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
