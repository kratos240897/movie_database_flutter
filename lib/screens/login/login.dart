import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/routes/router.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Styles.colors.primaryColor,
                            fontFamily: GoogleFonts.raleway().fontFamily)),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.verified_user),
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    validator: (value) {
                      if (!EmailValidator.validate(value!)) {
                        return 'Enter a valid email';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) => setState(() {
                      email = value;
                    }),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    validator: (value) => value != null && value.length < 8
                        ? 'password must be min 8 characters'
                        : null,
                    onChanged: (value) => setState(() {
                      password = value;
                    }),
                  ),
                  const SizedBox(height: 12.0),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('new user? want to',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: GoogleFonts.raleway().fontFamily)),
                    const SizedBox(width: 4.0),
                    InkWell(
                      onTap: () => Get.offNamed(AppRouter.REGISTER),
                      child: Text('Register',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0,
                              decoration: TextDecoration.underline,
                              fontFamily: GoogleFonts.readexPro().fontFamily)),
                    )
                  ]),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () async {
                            final isFormValid =
                                formKey.currentState!.validate();
                            if (isFormValid) {
                              Get.offNamed(AppRouter.HOME);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          icon: const FaIcon(FontAwesomeIcons.xbox),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 5.0),
                            child: Text('Submit'),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
