import 'package:bkb/views/Superadmin/ShowAllAccounts.dart';
import 'package:bkb/views/Superadmin/adminLogin.dart';
import 'package:bkb/views/auth/faceId.dart';
import 'package:bkb/views/auth/login.dart';
import 'package:bkb/views/auth/register.dart';
import 'package:bkb/views/auth/waitingScreen.dart';
import 'package:bkb/views/home/home.dart';
import 'package:bkb/views/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  //setHashUrlStrategy();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  //final List<CameraDescription> cameras;
  const MyApp({super.key,
    //required this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BKB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        //colorScheme: ColorScheme.dark() ,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      //initialRoute: MyRoutes.loginRoute,
      routes: {
        "/": (context) => Login(),
        MyRoutes.loginRoute: (context) => Login(),
        MyRoutes.registrationRoute: (context) => RegistrationPage(),
        //MyRoutes.accountStatus: (context) => WaitingScreen(),
        MyRoutes.adminLogin: (context) => AdminLogin(),
        MyRoutes.home: (context) => Home(),
        MyRoutes.registrationFace: (context) => FaceId(),
        MyRoutes.showAllAccounts: (context) => ShowAllAccounts(),
      },
      //home:  const UserOrSuperadmin(),
    );
  }
}
