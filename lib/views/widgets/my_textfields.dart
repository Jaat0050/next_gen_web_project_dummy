import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? inputType;
  final Function(String)? onChange;
  final int? maxLength;
  final bool? isObscure;
  final Widget? preffix;
  final Widget? suffix;
  final String fieldType;
  final int? maxLines;
  final bool readOnly;
  final double? radius;
  final double? verticalPadding;
  final bool autofocus;
  final List<dynamic>? inputFormatters;
  const MyTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.fieldType,
      this.onChange,
      this.maxLength,
      this.isObscure = false,
      this.inputType,
      this.maxLines,
      this.suffix,
      this.preffix,
      this.radius,
      this.verticalPadding,
      this.autofocus = false,
      required this.readOnly,
      this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      obscureText: isObscure!,
      keyboardType: inputType,
      onChanged: onChange,
      maxLines: maxLines,
      readOnly: readOnly,
      autofocus: autofocus,
      style: const TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
          hintText: hintText,
          counterText: "",
          hintStyle: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontFamily: "Fira Sans",
              fontWeight: FontWeight.w300),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
            borderSide: const BorderSide(color: Color(0xff586266), width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
            borderSide: const BorderSide(color: Color(0xff586266), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
            borderSide: const BorderSide(color: Color(0xff586266), width: 0.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
            borderSide: const BorderSide(color: Colors.red, width: 0.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 6)),
            borderSide: const BorderSide(color: Colors.red, width: 0.5),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? 15, horizontal: 15),
          prefixIcon: preffix,
          suffixIcon: suffix),
      cursorColor: Colors.black,
      onSaved: (newValue) => controller.text = newValue!,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return hintText;
        }

        //********* CHECK NUMBER *******/
        if (fieldType == "Mobile Number") {
          if (value.length != 10 || !validatePhone(value)) {
            return 'Please Enter valid Phone Number';
          }
        }

        //********* CHECK EMIAL *******/
        if (fieldType == "Email I'd" && !validateEmail(value)) {
          return 'Please Enter valid Email';
        }
        return null;
      },
    );
  }
}

bool validatePhone(String phone) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(patttern);
  return regExp.hasMatch(phone);
}

bool validateEmail(String email) {
  RegExp emailReg = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

  return emailReg.hasMatch(email);
}

// bool validateNoEmoji(String email) {
//   RegExp emailReg = RegExp(regexToRemoveEmoji);
//
//   return emailReg.hasMatch(email);
// }

//inputFormatters: [FilteringTextInputFormatter.deny(RegExp(regexToRemoveEmoji))],
