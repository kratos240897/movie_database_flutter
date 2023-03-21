import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/components/custom_textformfield.dart';
import '../../core/init/routes/router.dart';
import '../../core/service/theme_service.dart';
import 'login_controller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginController _controller = Get.find<LoginController>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.raleway().fontFamily)),
                  ),
                  const SizedBox(height: 8.0),
                  CustomTextFormField(
                      inputType: TextInputType.emailAddress,
                      isObscure: false,
                      obscureTextOnPressedCallBack: null,
                      controller: emailController,
                      validatorCallBack: (value) {
                        if (!GetUtils.isEmail(value!)) {
                          return 'Enter a valid email';
                        } else {
                          return null;
                        }
                      },
                      labelText: 'Email',
                      prefixIcon: Icons.verified_user,
                      isObscureField: false),
                  const SizedBox(height: 10.0),
                  CustomTextFormField(
                      inputType: TextInputType.text,
                      isObscure: _isObscure,
                      isObscureField: true,
                      obscureTextOnPressedCallBack: () => setState(() {
                            _isObscure = !_isObscure;
                          }),
                      controller: passwordController,
                      validatorCallBack: (value) =>
                          value != null && value.length < 8
                              ? 'password must be min 8 characters'
                              : null,
                      labelText: 'Password',
                      prefixIcon: Icons.lock),
                  const SizedBox(height: 12.0),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('new user? want to',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 14.sp,
                            fontFamily: GoogleFonts.raleway().fontFamily)),
                    const SizedBox(width: 4.0),
                    InkWell(
                      onTap: () => Get.offNamed(PageRouter.REGISTER),
                      child: Text('Register',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
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
                              _controller.login(emailController.text.trim(),
                                  passwordController.text.trim());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeService().isDarkMode()
                                  ? Colors.white
                                  : Colors.black,
                              shape: const StadiumBorder()),
                          icon: FaIcon(FontAwesomeIcons.xbox,
                              color: ThemeService().isDarkMode()
                                  ? Colors.black
                                  : Colors.white),
                          label: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 12.w),
                            child: Text('SUBMIT',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: ThemeService().isDarkMode()
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.raleway().fontFamily)),
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
