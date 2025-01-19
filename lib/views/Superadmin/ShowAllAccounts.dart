import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/color_theme.dart';
import '../routes/routes.dart';
import 'Users_List/ActiveUsersList.dart';
import 'Users_List/InActiveUsersList.dart';
import 'dart:html' as html;

import 'adminLogin.dart';

class ShowAllAccounts extends StatefulWidget {
  const ShowAllAccounts({Key? key}) : super(key: key);

  @override
  State<ShowAllAccounts> createState() => _ShowAllAccountsState();
}

class _ShowAllAccountsState extends State<ShowAllAccounts> {
  String _selectedCategory = "Active Users";
  bool showSidebar = false;

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = html.window.localStorage.containsKey('token');
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: !isLoggedIn
          ? AdminLogin()
          : LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile Layout
            return buildMobileLayout(size);
          } else {
            // Desktop Layout
            return buildDesktopLayout(size);
          }
        },
      ),
    );
  }

  Widget buildMobileLayout(Size size) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.darkBg,
        foregroundColor: Colors.white,
        title: Text("BKB"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            setState(() {
              print("showSidebar: $showSidebar");
              showSidebar = !showSidebar;
            });
          },
        ),
      ),
      body: showSidebar
          ? buildSidebar(size)
          : _selectedCategory == "Active Users"
          ? ActiveUsersList()
          : InActiveUsersList(),
      backgroundColor: ColorTheme.darkBg,
    );
  }

  Widget buildDesktopLayout(Size size) {
    return Row(
      children: [
        Container(
          width: size.width * 0.2,
          color: ColorTheme.sidebar,
          child: buildSidebar(size),
        ),
        // Right Content
        Expanded(
          child: _selectedCategory == "Active Users"
              ? ActiveUsersList()
              : InActiveUsersList(),
        ),
      ],
    );
  }

  Widget buildSidebar(Size size) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.data_usage,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "BKB",
                  style: GoogleFonts.mulish(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Users",
                  style: GoogleFonts.mulish(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildCategoryTile("Active Users", Icons.check_box),
          buildCategoryTile("Pending Users", Icons.pending_actions),
          SizedBox(
            height: size.height * 0.3,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                logout();
              },
              child: Row(
                children: [
                  Text(
                    'Logout',
                    style: GoogleFonts.mulish(
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                  ),
                  Icon(
                    Icons.exit_to_app_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
    );
  }

  ListTile buildCategoryTile(String category, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: _selectedCategory == category
            ? ColorTheme.lightPurple
            : Colors.white,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            category,
            style: GoogleFonts.mulish(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _selectedCategory == category
                    ? ColorTheme.lightPurple
                    : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 38,),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18.0,
            color: _selectedCategory == category
                ? ColorTheme.lightPurple
                : Colors.white,
          ),
        ],
      ),
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
    );
  }

  void logout() {
    html.window.localStorage.remove('token');
    Navigator.pushNamed(context, MyRoutes.adminLogin);
  }
}
