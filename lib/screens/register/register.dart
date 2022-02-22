import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_database/helpers/styles.dart';
import 'package:movie_database/routes/router.dart';
import 'package:movie_database/screens/register/register_controller.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final RegisterController _controller = Get.find<RegisterController>();
  bool _isObscure = true;
  String name = '';
  String phone = '';
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Register',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Styles.colors.primaryColor,
                              fontFamily: GoogleFonts.raleway().fontFamily)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          return GestureDetector(
                            onTap: () => _controller.pickImage(),
                            child: SizedBox(
                              width: 90.0,
                              height: 90.0,
                              child: _controller.isImageNotNull.value == true
                                  ? ClipOval(
                                      child: Image.file(_controller.file!,
                                          fit: BoxFit.cover))
                                  : ClipOval(
                                      child: Image.asset(
                                          'assets/images/user.png',
                                          fit: BoxFit.cover),
                                    ),
                            ),
                          );
                        })
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      validator: (value) {
                        // ignore: prefer_is_empty
                        if (value!.length < 1) {
                          return 'Enter a valid name';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() {
                        name = value;
                      }),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone),
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      validator: (value) {
                        // ignore: prefer_is_empty
                        if (value!.length < 10) {
                          return 'Enter a valid phone number';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => setState(() {
                        name = value;
                      }),
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
                    const SizedBox(height: 12.0),
                    TextFormField(
                      obscureText: _isObscure ? true : false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
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
                      Text('already registered? want to',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: GoogleFonts.raleway().fontFamily)),
                      const SizedBox(width: 4.0),
                      InkWell(
                        onTap: () => Get.offNamed(AppRouter.LOGIN),
                        child: Text('Login',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0,
                                decoration: TextDecoration.underline,
                                fontFamily:
                                    GoogleFonts.readexPro().fontFamily)),
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
                                _controller.register(email, password);
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
      ),
    );
  }
}
