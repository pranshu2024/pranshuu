import 'package:flutter/material.dart';
import 'package:prophunter/constant.dart';
import 'package:prophunter/screens/register_page.dart';
import 'package:prophunter/services/auth.dart';
import 'package:prophunter/size_config.dart';
import 'package:prophunter/widgets/buttons.dart';
import 'package:prophunter/widgets/loading_dialog.dart';
import 'package:prophunter/widgets/text.dart';

import '../widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/login_page';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String error = "";
  String? password;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Image.asset(
                    'assets/images/transparent_logo.png',
                    width: SizeConfig.screenWidth * 0.8,
                  ),
                  const Spacer(),
                  TextFormField(
                    onSaved: (val) => email = val,
                    validator: (val) => validateEmail(val),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputDecoration.copyWith(labelText: 'Email'),
                  ),
                  defaultSpace3x,
                  defaultSpace2x,
                  TextFormField(
                    onSaved: (val) => password = val,
                    style: const TextStyle(color: Colors.white),
                    decoration: inputDecoration.copyWith(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  defaultSpace2x,
                  Text(
                    error,
                    style: titleWhite18,
                  ),
                  const Spacer(),
                  DefaultButton(
                    text: "LOGIN",
                    press: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        showLoaderDialog(context);
                        String? result = await AuthenticationHelper().signIn(
                            email: email ?? "", password: password ?? "");
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        error = result!;
                        setState(() {});
                      }
                    },
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't have account?",
                        style: titleWhite18,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegisterPage.routeName);
                          },
                          child: const Text('Create Account'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
