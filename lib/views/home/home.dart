import 'dart:math';
import 'package:bkb/views/auth/login.dart';
import 'package:bkb/views/routes/routes.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import '../../data/repos/api_repo.dart';
import '../../shared_pref_helper.dart';
import '../../utils/color_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

import '../auth/waitingScreen.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //late final bool isLoggedIn;
  bool isActive = false;
  String userId = "";

  Future<dynamic> fetchData(String userId) async {

    //if (html.window.localStorage.containsKey('number')) {
   // String? mobileNumber = html.window.localStorage['number'];
   // String mobileNumber = await SharedPreferencesHelper.getUserMobileNumber();
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
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      userId = arguments?['user_id'] ?? '';
      print("-------------");
      print(userId);
      fetchData(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.darkBg,
      body: !isActive
            ? WaitingScreen(userId: userId,)
          : SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    // Mobile
                    // return Column(
                    //   children: [
                    //     for (int i = 0; i < 6; i++)
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           _buildCircularContainer(
                    //             index: i,
                    //             firstColor: Colors.blue,
                    //             otherColor: Colors.grey,
                    //             onTap: () async {
                    //               if (i == 0) {
                    //                 const chars =
                    //                     'abcdefghijklmnopqrstuvwxyz0123456789';
                    //                 final random = Random();
                    //                 String roomLink =
                    //                     'https://tip-vvip.vercel.app/join/' +
                    //                         '-' +
                    //                         DateTime.now()
                    //                             .millisecondsSinceEpoch
                    //                             .toString() +
                    //                         '-' +
                    //                         String.fromCharCodes(
                    //                           Iterable.generate(
                    //                             5,
                    //                             (_) => chars.codeUnitAt(random
                    //                                 .nextInt(chars.length)),
                    //                           ),
                    //                         );
                    //                 //print(roomLink);
                    //                 showDialogExample(context, roomLink);
                    //               }
                    //             },
                    //           ),
                    //           _buildCircularContainer(
                    //             index: i,
                    //             firstColor: Colors.grey,
                    //             otherColor: Colors.grey,
                    //             onTap: () {},
                    //           ),
                    //         ],
                    //       ),
                    //   ],
                    // );
                    return Padding(
                      padding: EdgeInsets.only(top:100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 6; i++)
                                  _buildCircularContainerForMobile(
                                    index: i,
                                    firstColor: Colors.purple,
                                    otherColor: Colors.grey,
                                    onTap: () async {
                                      if (i == 0) {
                                        const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
                                        final random = Random();
                                        String roomLink = 'https://call.seedmount.tech/join/' +
                                            '-' +
                                            DateTime.now().millisecondsSinceEpoch.toString() +
                                            '-' +
                                            String.fromCharCodes(
                                              Iterable.generate(
                                                5,
                                                    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
                                              ),
                                            );
                                        showDialogExample(context, roomLink);
                                      }
                                    },
                                  ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Image.asset(
                                'assets/tree.png',
                                width: 250,
                                height: 250,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 0; i < 6; i++)
                                  _buildCircularContainerForMobile(
                                    index: i,
                                    firstColor: Colors.grey,
                                    otherColor: Colors.grey,
                                    onTap: () {},
                                  ),
                              ],
                            ),
                          ],
                        ),
                    );
                  } else {
                    // PC
                    // return Column(
                    //   children: [
                    //     SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.1,
                    //     ),
                    //     // const Center(
                    //     //   child: Text("This is Home"),
                    //     // ),
                    //     // const SizedBox(height: 20),
                    //     Padding(
                    //       padding:
                    //           const EdgeInsets.only(left: 50.0, right: 50.0),
                    //       child: Row(
                    //         children: [
                    //           for (int i = 0; i < 6; i++)
                    //             _buildCircularContainer(
                    //               index: i,
                    //               firstColor: Colors.blue,
                    //               otherColor: Colors.grey,
                    //               onTap: () async {
                    //                 if (i == 0) {
                    //                   const chars =
                    //                       'abcdefghijklmnopqrstuvwxyz0123456789';
                    //                   final random = Random();
                    //                   String roomLink =
                    //                       'https://tip-vvip.vercel.app/join/-${DateTime.now().millisecondsSinceEpoch}-${String.fromCharCodes(
                    //                     Iterable.generate(
                    //                       5,
                    //                       (_) => chars.codeUnitAt(
                    //                           random.nextInt(chars.length)),
                    //                     ),
                    //                   )}';
                    //                   //print(roomLink);
                    //                   showDialogExample(context, roomLink);
                    //                 }
                    //               },
                    //             ),
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(height: 30),
                    //     Padding(
                    //       padding:
                    //           const EdgeInsets.only(left: 50.0, right: 50.0),
                    //       child: Row(
                    //         children: [
                    //           for (int i = 0; i < 6; i++)
                    //             _buildCircularContainer(
                    //               index: i,
                    //               firstColor: Colors.grey,
                    //               otherColor: Colors.grey,
                    //               onTap: () {},
                    //             ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // );
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 0; i < 6; i++)
                                _buildCircularContainer(
                                  index: i,
                                  firstColor: Colors.purple,
                                  otherColor: Colors.grey,
                                  onTap: () async {
                                    if (i == 0) {
                                      const chars =
                                          'abcdefghijklmnopqrstuvwxyz0123456789';
                                      final random = Random();
                                      String roomLink =
                                          'https://call.seedmount.tech/join/-${DateTime.now().millisecondsSinceEpoch}-${String.fromCharCodes(
                                        Iterable.generate(
                                          5,
                                              (_) => chars.codeUnitAt(
                                              random.nextInt(chars.length)),
                                        ),
                                      )}';
                                      showDialogExample(context, roomLink);
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: Image.asset(
                            'assets/tree.png',
                            height: 300,
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int i = 0; i < 6; i++)
                                _buildCircularContainer(
                                  index: i,
                                  firstColor: Colors.grey,
                                  otherColor: Colors.grey,
                                  onTap: () {},
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
    );
  }

  void showDialogExample(BuildContext context, String roomLink) {
    Size size = MediaQuery.of(context).size;
    double titleToIconDistance =
        size.width < 600 ? size.width * 0.03 : size.width * 0.045;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Text("Here's a link to your meeting"),
            SizedBox(width: titleToIconDistance),
            IconButton(
              icon: Image.asset(
                'assets/icons/cancel_icon.png',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Copy this link and send it to people you want to meet with.',
              style: GoogleFonts.mulish(
                textStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Color.fromRGBO(241, 243, 244, 1),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        roomLink,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        copyToClipboard(roomLink);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Link copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(bottom: 16, right: 16),
                            backgroundColor: Colors.black45,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCircularContainerForMobile({
    required int index,
    required Color firstColor,
    required Color otherColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double containerSize = constraints.maxWidth / 1.5; // Adjust as needed
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5), // Adjust the horizontal spacing
            child: Column(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: containerSize,
                      height: containerSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == 0 ? firstColor : otherColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildCircularContainer({
    required int index,
    required Color firstColor,
    required Color otherColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double containerSize = constraints.maxWidth / 2.5; // Adjust as needed
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5), // Adjust the horizontal spacing
            child: Column(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: containerSize,
                      height: containerSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == 0 ? firstColor : otherColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}

void copyToClipboard(String url) {
  FlutterClipboard.copy(url).then((value) {
    print('URL copied to clipboard: $url');
  });
}
