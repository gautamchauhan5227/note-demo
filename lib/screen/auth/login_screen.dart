import 'package:flutter/material.dart';
import 'package:keep_note/core/color_const.dart';
import 'package:keep_note/core/image_const.dart';
import 'package:keep_note/core/string_const.dart';
import 'package:keep_note/screen/home/home_screen.dart';
import 'package:keep_note/service/auth/auth_service.dart';
import 'package:keep_note/widget/primary_button.dart';
import 'package:provider/provider.dart';

import '../../widget/text_field_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    bool _validateEmail(String email) {
      // Regular expression to match the email pattern
      final RegExp emailRegex = RegExp(
          r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
      return emailRegex.hasMatch(email);
    }

    return ChangeNotifierProvider(
      create: (context) => AuthServiceModel(),
      child: Consumer<AuthServiceModel>(builder: (context, loginModel, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70, bottom: 30),
                  child: Image.asset(
                    ImageConstants.noteLogo,
                    height: 130,
                    width: 130,
                  ),
                ),
                const Center(
                  child: Text(
                    StringConsatant.noteKeep,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextFormFieldCustom(
                  labelText: StringConsatant.emailAddress,
                  onChanged: (val) => loginModel.setEmail(val),
                  errorText: loginModel.email.isEmpty ||
                          _validateEmail(loginModel.email)
                      ? ''
                      : 'Please enter your email address',
                ),
                const SizedBox(height: 20),
                TextFormFieldCustom(
                  labelText: StringConsatant.password,
                  onChanged: (val) => loginModel.setPassword(val),
                  obscureText: loginModel.showPassword ? false : true,
                  errorText: loginModel.password.isEmpty ||
                          loginModel.password.length > 8
                      ? ''
                      : 'Please enter 8 or more characters',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      loginModel.setShowPassword(!loginModel.showPassword);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      color: Colors.transparent,
                      child: Icon(
                        loginModel.showPassword
                            ? Icons.remove_red_eye_rounded
                            : Icons.remove_red_eye_outlined,
                        color: ColorConstants.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  isDisabled: !(_validateEmail(loginModel.email) ||
                      loginModel.password.length > 8),
                  isProgress: loginModel.isProgress,
                  onTap: () async {
                    final result = await loginModel.signInWithEmailPassword();
                    if (result == "success") {
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (route) => false);
                    } else {}
                  },
                  title: StringConsatant.signIn,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        StringConsatant.or,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  isProgress: loginModel.isProgressGoogle,
                  bgColor: Colors.white,
                  onTap: () async {
                    final result = await loginModel.signInWithGoogle();
                    if (result == "success") {
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (route) => false);
                    } else {}
                  },
                  title: StringConsatant.continueWithGoogle,
                  imagePath: ImageConstants.googleLogo,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
