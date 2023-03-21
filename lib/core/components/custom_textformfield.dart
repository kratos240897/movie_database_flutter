import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../service/theme_service.dart';

class CustomTextFormField extends StatelessWidget {
  final bool isObscure;
  final bool isObscureField;
  final VoidCallback? obscureTextOnPressedCallBack;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final String? Function(String?) validatorCallBack;
  final String labelText;
  final IconData prefixIcon;
  final TextInputType inputType;
  const CustomTextFormField(
      {Key? key,
      required this.isObscure,
      required this.obscureTextOnPressedCallBack,
      this.onChanged,
      required this.validatorCallBack,
      required this.labelText,
      required this.prefixIcon,
      required this.isObscureField,
      required this.inputType, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: isObscure ? true : false,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14.sp),
      decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: ThemeService().isDarkMode() ? Colors.white : Colors.black,
          ),
          labelText: labelText,
          suffixIcon: isObscureField
              ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: ThemeService().isDarkMode()
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: obscureTextOnPressedCallBack)
              : const SizedBox.shrink(),
          floatingLabelStyle:
              TextStyle(color: Theme.of(context).textTheme.displayLarge!.color!),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                  color: Theme.of(context).textTheme.displayLarge!.color!)),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: validatorCallBack,
      onChanged: (value) => onChanged,
    );
  }
}
