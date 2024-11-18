import 'package:agriplant/pages/auth/signup.dart';
import 'package:agriplant/widgets/custom_btn.dart';
import 'package:agriplant/widgets/custom_icon.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Image.asset('assets/onboarding.png'),
              ),
              const Spacer(),
              Text('Chào mừng đến với\n',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  "Ứng dụng quản lý Nhật ký sản xuất tiện lợi, hiệu quả, chuyên nghiệp.",
                  textAlign: TextAlign.center,
                ),
              ),
              FadeInLeft(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      context.push("/login");
                    },
                    icon: const CustomIcon(IconlyBroken.login),
                    label: const Text("Đăng nhập"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FadeInRight(
                  child: CustomBtn(
                icon: IconlyBroken.addUser,
                text: "Đăng ký",
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupPage())),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
