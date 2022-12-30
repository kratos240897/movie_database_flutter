import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../routes/router.dart';
import '../../service/theme_service.dart';
import '../../widgets/custom_textformfield.dart';
import 'register_controller.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final RegisterController _controller = Get.find<RegisterController>();
  bool _isObscure = true;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Register',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      GoogleFonts.raleway().fontFamily)),
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
                    8.verticalSpace,
                    CustomTextFormField(
                        inputType: TextInputType.name,
                        isObscure: false,
                        obscureTextOnPressedCallBack: null,
                        controller: nameController,
                        validatorCallBack: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a valid name';
                          } else {
                            return null;
                          }
                        },
                        labelText: 'Name',
                        prefixIcon: Icons.person,
                        isObscureField: false),
                    8.verticalSpace,
                    CustomTextFormField(
                        inputType: TextInputType.phone,
                        isObscure: false,
                        obscureTextOnPressedCallBack: null,
                        controller: phoneController,
                        validatorCallBack: (value) {
                          if (value!.length < 10) {
                            return 'Enter a valid phone number';
                          } else {
                            return null;
                          }
                        },
                        labelText: 'Phone',
                        prefixIcon: Icons.phone,
                        isObscureField: false),
                    8.verticalSpace,
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
                        prefixIcon: Icons.email_rounded,
                        isObscureField: false),
                    8.verticalSpace,
                    CustomTextFormField(
                        inputType: TextInputType.text,
                        isObscure: _isObscure,
                        isObscureField: true,
                        controller: passwordController,
                        obscureTextOnPressedCallBack: () => setState(() {
                              _isObscure = !_isObscure;
                            }),
                        validatorCallBack: (value) =>
                            value != null && value.length < 8
                                ? 'password must be min 8 characters'
                                : null,
                        labelText: 'Password',
                        prefixIcon: Icons.lock),
                    const SizedBox(height: 12.0),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('already registered? want to',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  fontSize: 14.sp,
                                  fontFamily:
                                      GoogleFonts.raleway().fontFamily)),
                      const SizedBox(width: 4.0),
                      InkWell(
                        onTap: () => Get.offNamed(PageRouter.LOGIN),
                        child: Text('Login',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
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
                                _controller.register(
                                    emailController.text.trim(),
                                    passwordController.text.trim());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeService().isDarkMode()
                                    ? Colors.white
                                    : Colors.black,
                                shape: const StadiumBorder()),
                            icon: FaIcon(
                              FontAwesomeIcons.xbox,
                              color: ThemeService().isDarkMode()
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 5.0),
                              child: Text('Submit',
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
      ),
    );
  }
}
