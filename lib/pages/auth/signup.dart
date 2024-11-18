import 'package:agriplant/pages/auth/signin.dart';
import 'package:agriplant/widgets/custom_btn.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? selectedRole;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/login.png"),
                          const SizedBox(
                            height: 50,
                          ),
                          roleWidget(context),
                          const SizedBox(
                            height: 10,
                          ),
                          // FadeIn(child: InputField(hintText: "Username")),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // FadeIn(child: InputField(hintText: "dion@example.com")),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // FadeIn(
                          //   child: InputFieldPassword(
                          //     hintText: "Password",
                          //   ),
                          // ),
                          const CheckerBox(),
                          FadeInUp(
                            child: CustomBtn(
                              icon: IconlyLight.login,
                              text: "Sign Up",
                              onPressed: () => context.go("/login"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Text.rich(
                              TextSpan(
                                  text: "I already have an account ",
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(0.8),
                                      fontSize: 16),
                                  children: [
                                    TextSpan(
                                        text: "Sign In",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 16),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SigninPage()));
                                            print("Sign in click");
                                          }),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
    );
  }

Row roleWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: BounceInLeft(
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedRole = "Former";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedRole == "Former"
                      ? Theme.of(context).colorScheme.primary
                      : Colors.green[50],
                ),
                child: Text(
                  "Former",
                  style: TextStyle(
                    color: selectedRole == "Former"
                        ? Colors.green[50]
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: BounceInRight(
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedRole = "Buyer";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedRole == "Buyer"
                      ? Theme.of(context).colorScheme.primary
                      : Colors.green[50],
                ),
                child: Text(
                  "Buyer",
                  style: TextStyle(
                    color: selectedRole == "Buyer"
                        ? Colors.green[50]
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CheckerBox extends StatefulWidget {
  const CheckerBox({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckerBox> createState() => _CheckerBoxState();
}

class _CheckerBoxState extends State<CheckerBox> {
  bool? isCheck;
  @override
  void initState() {
    // TODO: implement initState
    isCheck = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
            value: isCheck,
            checkColor: Colors.white, // color of tick Mark
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (val) {
              setState(() {
                isCheck = val!;
                print(isCheck);
              });
            }),
        Text.rich(
          TextSpan(
              text: "I agree with ",
              style:
                  TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 16),
              children: [
                TextSpan(
                    text: "Terms ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16)),
                const TextSpan(text: "and "),
                TextSpan(
                    text: "Policy",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16)),
              ]),
        ),
      ],
    );
  }
}
