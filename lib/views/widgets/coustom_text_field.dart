
import 'package:bkb/views/widgets/text_field_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../utils/color_theme.dart';
//import 'package:velocity_x/velocity_x.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final int? maxLength;
  final int? maxLines;
  final TextInputType inputType;
  final TextFieldWrapper wrapper;
  final bool isEnabled;
  final Widget? suffixIcon;
  final bool readOnly;
  final Color color;
  final bool? obscureText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final VoidCallback? onFocusChanged;


  CustomTextField({
     this.onChanged,
    this.obscureText = false,
    required this.wrapper,
    required this.hintText,
    this.maxLength,
    this.maxLines,
    this.inputType = TextInputType.text,
    this.isEnabled = true,
    this.suffixIcon,
    this.readOnly = false,  this.color = const Color.fromRGBO(24, 29, 31, 1),
    this.validator,
    this.focusNode,
    this.onFocusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      onFocusChange: (hasFocus) {
        if (onFocusChanged != null) {
          onFocusChanged!();
        }
      },
      child: Obx(
        () => TextField(
            onChanged: (String newValue) {
            if (onChanged != null) {
              onChanged!(newValue);
            }
          },
          obscureText: obscureText!,
          controller: wrapper.controller,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontFamily: "Fira Sans",
          ),
          maxLength: maxLength,
          maxLines: obscureText! ? 1 : maxLines,
          keyboardType: inputType,
          enabled: isEnabled,
          readOnly: readOnly,
          decoration: InputDecoration(
            errorText: wrapper.errorText.isEmpty ? null : wrapper.errorText,
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w300,
              fontFamily: "Fira Sans",
            ),
            counterText: '',
            fillColor: color,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Color.fromRGBO(224, 224, 224, 0.2),
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: "Roboto",
            ),
            suffixIcon: suffixIcon,
            enabled: isEnabled,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            focusColor: Colors.black,
            focusedBorder: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(
                width: 1,
                color: ColorTheme.purple,
              ),
              //borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(
                width: 1,
                color:Color.fromRGBO(224, 224, 224, 0.4),
              ),
              borderRadius: BorderRadius.circular(10.0),
              //borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              //borderRadius: BorderRadius.circular(8.0),
            ),
            disabledBorder: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              //borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
