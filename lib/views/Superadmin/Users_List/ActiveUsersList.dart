import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../data/repos/api_repo.dart';
import '../../../utils/color_theme.dart';
import '../../models/Users.dart';

class ActiveUsersList extends StatefulWidget {
  @override
  State<ActiveUsersList> createState() => _ActiveUsersListState();
}

class _ActiveUsersListState extends State<ActiveUsersList> {
  final ApiRepo apiRepo = ApiRepo();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorTheme.darkBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SizedBox(
              width: size.width * 0.7,
              child: FutureBuilder<List<User>>(
                future: apiRepo.fetchActiveUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No active users available.'));
                  } else {
                    List<User> activeUsers = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Welcome, Super admin!!",
                            style: GoogleFonts.mulish(
                              textStyle: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: activeUsers.length,
                            itemBuilder: (context, index) {
                              return AccountCard(
                                name: activeUsers[index].name,
                                email: activeUsers[index].email,
                                mobileNumber: activeUsers[index].mobileNumber,
                                onDisabled: () async {
                                  String id = activeUsers[index].id;
                                  try {
                                    var response = await apiRepo.changeAccountStatus(id);
                                    print(response);
                                    if (response != null && response['status'] == 'success') {
                                      Fluttertoast.showToast(
                                        msg: 'Account deactivated successfully',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                      );
                                      setState(() {});
                                    } else {
                                      print('Failed to change account status');
                                    }
                                  } catch (error) {
                                    print('Error: $error');
                                  }
                                },
                                onViewDocuments: () {
                                  _showDocumentsDialog(activeUsers, index);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDocumentsDialog(List<User> activeUsers, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: size.width * 0.3,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  activeUsers[index].name,
                  style: GoogleFonts.mulish(
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildDocumentRow("Aadhar Front", activeUsers[index].adharFront),
                _buildDocumentRow("Aadhar Back", activeUsers[index].adharBack),
                _buildDocumentRow("PAN Front", activeUsers[index].panFront),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentRow(String title, String url) {
    return Row(
      children: [
        Text(
          title + ": ",
          style: GoogleFonts.mulish(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            print(url);
            _showImageDialog(url);
          },
          child: Text(
            "View Document",
            style: GoogleFonts.mulish(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showImageDialog(String imageUrl) {
    print('cchbvcgfcvhg');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Image.network(
              imageUrl,
              width: 300,
              height: 300,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return ErrorWidget('Failed to load image: $error');
              },
            ),
          ),
        );
      },
    );
  }
}

class AccountCard extends StatelessWidget {
  final String name;
  final String email;
  final String mobileNumber;
  final VoidCallback onDisabled;
  final VoidCallback onViewDocuments;

  AccountCard({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.onDisabled,
    required this.onViewDocuments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorTheme.cardColor,
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: $name",
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Email: $email",
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Mobile: $mobileNumber",
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onViewDocuments,
                  icon: Icon(Icons.visibility),
                  tooltip: 'View Documents',
                  color: Colors.white,
                  iconSize: 24.0,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onDisabled,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Disable",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.block, size: 20, color: Colors.white,),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
}