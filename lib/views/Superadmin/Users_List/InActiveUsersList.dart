import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/repos/api_repo.dart';
import '../../../utils/color_theme.dart';
import '../../models/InActiveUser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InActiveUsersList extends StatefulWidget {
  @override
  State<InActiveUsersList> createState() => _InActiveUsersListState();
}

class _InActiveUsersListState extends State<InActiveUsersList> {
  final ApiRepo apiRepo = ApiRepo();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorTheme.darkBg,
      body: Center(
        child: SizedBox(
          width: size.width * 0.7,
          child: FutureBuilder<List<InActiveUser>>(
            future: apiRepo.fetchInActiveUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No pending users available.'));
              } else {
                List<InActiveUser> inActiveUsers = snapshot.data!;
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
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: inActiveUsers.length,
                        itemBuilder: (context, index) {
                          return AccountCard(
                            name: inActiveUsers[index].name,
                            email: inActiveUsers[index].email,
                            mobileNumber: inActiveUsers[index].mobileNumber,
                            onApprove: () async {
                              String id = inActiveUsers[index].id;
                              try {
                                var response = await apiRepo.changeAccountStatus(id);
                                print(response);
                                if (response != null && response['status'] == 'success') {
                                  Fluttertoast.showToast(
                                    msg: 'Account Activated successfully',
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
                            onReject: () async {
                              String id = inActiveUsers[index].id;
                              try {
                                var response = await apiRepo.reject(id);
                                print(response);
                                if (response != null && response['status'] == 'success') {
                                  Fluttertoast.showToast(
                                    msg: 'Account rejected successfully',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                  setState(() {});
                                } else {
                                  print('Failed to reject user');
                                }
                              } catch (error) {
                                print('Error: $error');
                              }
                            },
                            onViewDocuments: () {
                              _showDocumentsDialog(inActiveUsers, index);
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
      ),
    );
  }
  void _showDocumentsDialog(List<InActiveUser> activeUsers, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Image(
              image: NetworkImage(imageUrl),
              width: 300,
              height: 300,
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
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onViewDocuments;

  AccountCard({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.onApprove,
    required this.onReject,
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
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Approve",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Icon(Icons.check, size: 20, color: Colors.white,),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Reject",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 17.0),
                      Image.asset(
                        'assets/icons/cancel_icon.png',
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
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

