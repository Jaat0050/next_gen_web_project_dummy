import 'package:flutter/material.dart';
import '../../data/repos/api_repo.dart';
import '../../utils/color_theme.dart';
import '../routes/routes.dart';
import '../widgets/coustom_text_field.dart';
import '../widgets/text_field_wrapper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final emailWrapper = TextFieldWrapper();
  final passwordWrapper = TextFieldWrapper();
  final ApiRepo apiRepo = ApiRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.sidebar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return buildWebLayout();
          // if (constraints.maxWidth < 600) {
          //   // mobile
          //   return buildWebLayout();
          // } else {
          //   // web
          //   return buildWebLayout();
          // }
        },
      ),
    );
  }

  Widget buildWebLayout() {
    return Center(
      child: Container(
        width: 400,
        height: 450,
        child: Card(
          color: ColorTheme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello! Let's get started.",
                  style: GoogleFonts.mulish(
                    textStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Sign in to continue",
                  style: GoogleFonts.mulish(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  wrapper: emailWrapper,
                  hintText: "Enter Email",
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  wrapper: passwordWrapper,
                  hintText: "Enter password",
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => onSignInPressed(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorTheme.purpleBg,
                        backgroundColor: ColorTheme.lightPurple,
                        padding: EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        textStyle: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text("Sign In"),
                    ),
                    const SizedBox(width: 20,),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){},
                        child: Text(
                          'Reset Password',
                           style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                             decoration: TextDecoration.underline,
                             decorationColor: Colors.white
                            ),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void onSignInPressed(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      String email = emailWrapper.controller.text;
      String password = passwordWrapper.controller.text;

      var result = await apiRepo.adminLogin(email, password);

      Navigator.pop(context);

      if (result != null && result['status'] == "success") {
        Navigator.pushNamed(context, MyRoutes.showAllAccounts);
      } else {
        Fluttertoast.showToast(
          msg: "Login failed. Please check your credentials.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);

      Fluttertoast.showToast(
        msg: "An error occurred. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Widget buildMobileLayout() {
    return Center(
      child: Container(
        width: 400,
        height: 450,
        child: Card(
          color: ColorTheme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello! Let's get started.",
                  style: GoogleFonts.mulish(
                    textStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Sign in to continue",
                  style: GoogleFonts.mulish(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  wrapper: emailWrapper,
                  hintText: "Enter Email",
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  wrapper: passwordWrapper,
                  hintText: "Enter password",
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => onSignInPressed(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorTheme.purpleBg,
                    backgroundColor: ColorTheme.lightPurple,
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("Sign In"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
