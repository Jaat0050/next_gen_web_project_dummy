import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repos/api_repo.dart';
import '../../shared_pref_helper.dart';
import '../../utils/color_theme.dart';
import '../routes/routes.dart';
import 'dart:html' as html;

import 'login.dart';

class WaitingScreen extends StatefulWidget {
  final String userId;
  const WaitingScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  bool isActive = false;
  //String mobileNumber = SharedPreferencesHelper.getUserMobileNumber();
  //late Future<bool> isLoggedIn;

  Future<dynamic> fetchData(String userId) async {

    print("Inside fetch data");
    print(userId);
    ApiRepo apiRepo = ApiRepo();
    var result = await apiRepo.fetchAccountStatus(userId);
    isActive = result['data'][0]['isActive'];
    print("--------------");
    print(isActive);
    setState(() {

    });
  }

  @override
  void initState(){
    super.initState();
    fetchData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.darkBg,
      body: isActive
            ? Approved()
            : WaitingForApproval()
    );
  }
}

class Approved extends StatelessWidget {
  const Approved({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/emojis/happy.png",
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Your account is verified.",
              style: GoogleFonts.mulish(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutes.loginRoute);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorTheme.purpleBg,
              backgroundColor: ColorTheme.lightPurple,
              padding: EdgeInsets.all(16.0), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
              textStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}

class WaitingForApproval extends StatelessWidget {
  const WaitingForApproval({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/emojis/waiting_for_superadmin.png",
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "We will update you,",
              style: GoogleFonts.mulish(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              "Once your account is verified.\n",
              style: GoogleFonts.mulish(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, MyRoutes.loginRoute);
          //     },
          //     style: ElevatedButton.styleFrom(
          //       foregroundColor: ColorTheme.purpleBg,
          //       backgroundColor: ColorTheme.lightPurple,
          //       padding: EdgeInsets.all(16.0), // Button padding
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(3.0),
          //       ),
          //       textStyle: TextStyle(
          //         fontSize: 18.0,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     child: Text("Go to log in"),
          // ),
        ],
      ),
    );
  }
}