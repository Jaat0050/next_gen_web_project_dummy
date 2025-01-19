import 'dart:developer';
import 'dart:html' as html;
import 'dart:html';
import 'package:bkb/views/widgets/coustom_text_field.dart';
import 'package:bkb/views/widgets/dragAndDrop.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import '../../data/repos/api_repo.dart';
import '../../utils/color_theme.dart';
import '../routes/routes.dart';
import '../widgets/text_field_wrapper.dart';
import 'dart:typed_data' show Uint8List;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  //final List<CameraDescription> cameras;

  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final ApiRepo apiRepo = ApiRepo();

  String selectedOption = 'Driving licence';
  final nameWrapper = TextFieldWrapper();
  final phoneWrapper = TextFieldWrapper();
  final emailWrapper = TextFieldWrapper();
  final mobileOTPWrapper = TextFieldWrapper();
  final emailOTPWrapper = TextFieldWrapper();
  final aadharOTPWrapper = TextFieldWrapper();

  html.File _aadharFrontFile = html.File([], '');
  html.File _aadharBackFile = html.File([], '');
  html.File _panCardFile = html.File([], '');
  html.File _optionalFile = html.File([], '');
  Uint8List? aadharFrontWebImage;
  Uint8List? aadharBackWebImage;
  Uint8List? panCardWebImage;
  Uint8List? optionalWebImage;

  bool MobileOtpSent = false;
  bool EmailOtpSent = false;
  bool AadharOtpSent = false;

  bool isPhoneNumberVerified = false;
  bool isEmailVerified = false;
  bool isAadhaarVerified = false;
  bool isPanVerified = false;

  Uint8List? _bytesData;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  late File _panFront;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _numberFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorTheme.darkBg,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 850) {
              //Mobile
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Registration Details",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      //Full Name
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: [
                            Text(
                              "Name  ",
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "(as per Aadhaar)",
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(255, 255, 255, 0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: SizedBox(
                          height: 50,
                          width: size.width * 0.8,
                          child: CustomTextField(
                            wrapper: nameWrapper,
                            hintText: "Enter your full name",
                            focusNode: _nameFocus,
                            onFocusChanged: () {
                              _handleFocusChange();
                            },
                          ),
                        ),
                      ),

                      //Phone Number
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Phone Number",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _numberFocus.hasFocus
                                  ? ColorTheme.purple
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: size.width * 0.6,
                              child: CustomTextField(
                                wrapper: phoneWrapper,
                                hintText: "Enter your phone number",
                                focusNode: _numberFocus,
                                onFocusChanged: () {
                                  _handleFocusChange();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  await sendMobileOTP();
                                },
                                child: Text(
                                  'Send OTP',
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Enter OTP",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: MobileOtpSent
                                  ? Color.fromRGBO(224, 224, 224, 1)
                                  : Color.fromRGBO(224, 224, 224, 0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: size.width * 0.6,
                              child: CustomTextField(
                                wrapper: mobileOTPWrapper,
                                hintText: "Enter OTP",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await verifyMobileOTP();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: MobileOtpSent
                                      ? ColorTheme.purple
                                      : const Color.fromRGBO(186, 68, 197, 0.4),
                                  padding: EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: MobileOtpSent
                                        ? Color.fromRGBO(224, 224, 224, 1)
                                        : Color.fromRGBO(224, 224, 224, 0.4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isPhoneNumberVerified)
                        Padding(
                          padding: const EdgeInsets.only(left: 23.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Phone number verified successfully",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/icons/verified_new.png',
                                width: 18,
                                height: 18,
                              )
                            ],
                          ),
                        ),

                      //Email Address
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Email address",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _emailFocus.hasFocus
                                  ? ColorTheme.purple
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: size.width * 0.6,
                              child: CustomTextField(
                                wrapper: emailWrapper,
                                hintText: "Enter your email Id",
                                focusNode: _emailFocus,
                                onFocusChanged: () {
                                  _handleFocusChange();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  await sendEmailOTP();
                                },
                                child: Text(
                                  'Send OTP',
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Enter OTP",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: EmailOtpSent
                                  ? Color.fromRGBO(224, 224, 224, 1)
                                  : Color.fromRGBO(224, 224, 224, 0.4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: size.width * 0.6,
                              child: CustomTextField(
                                wrapper: emailOTPWrapper,
                                hintText: "Enter OTP",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await verifyEmailOTP();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: EmailOtpSent
                                      ? ColorTheme.purple
                                      : const Color.fromRGBO(186, 68, 197, 0.4),
                                  padding: EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: EmailOtpSent
                                        ? Color.fromRGBO(224, 224, 224, 1)
                                        : Color.fromRGBO(224, 224, 224, 0.4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isEmailVerified)
                        Padding(
                          padding: const EdgeInsets.only(left: 23.0),
                          child: Row(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Email verified successfully",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'assets/icons/verified_new.png',
                                width: 18,
                                height: 18,
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Aadhaar Card",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Row(
                            children: [
                              DragAndDrop(
                                onTap: () {
                                  uploadImage(1);
                                },
                                //imagePath: _aadharFrontFile.url,
                                webImage: aadharFrontWebImage,
                                text: '(Front Image)', width: 0.39,
                              ),
                              const SizedBox(width: 15),
                              DragAndDrop(
                                onTap: () {
                                  uploadImage(2);
                                },
                                //imagePath: _aadharBackFile.path,
                                webImage: aadharBackWebImage,
                                text: '(Back Image)', width: 0.39,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Text(
                        //   "Enter OTP",
                        //   style: GoogleFonts.roboto(
                        //     textStyle: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.w500,
                        //       color: EmailOtpSent
                        //           ? Color.fromRGBO(224, 224, 224, 1)
                        //           : Color.fromRGBO(224, 224, 224, 0.4),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     SizedBox(
                        //       height: 50,
                        //       width: size.width * 0.6,
                        //       child: CustomTextField(
                        //         wrapper: aadharOTPWrapper,
                        //         hintText: "Enter OTP",
                        //       ),
                        //     ),
                        //     const SizedBox(
                        //       width: 10,
                        //     ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: ElevatedButton(
                            onPressed: aadharFrontWebImage == null ||
                                    aadharBackWebImage == null
                                ? () {
                                    print('1st one');
                                  }
                                : isAadhaarVerified &&
                                        aadharFrontWebImage != null &&
                                        aadharBackWebImage != null
                                    ? () {
                                        print('2nd one');
                                      }
                                    : () async {
                                        print('last one');

                                        var response =
                                            await apiRepo.aadharVerifyCashfree(
                                                _aadharFrontFile,
                                                _aadharBackFile);
                                        print(response);

                                        if (response == nameWrapper.toString) {
                                          setState(() {
                                            isAadhaarVerified = true;
                                          });
                                          Fluttertoast.showToast(
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Color.fromRGBO(235, 93, 28, 1),
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                            msg:
                                                "Aadhaar Verification Successful",
                                          );
                                        } else {
                                          setState(() {
                                            isAadhaarVerified = false;
                                            aadharFrontWebImage = null;
                                            aadharBackWebImage = null;
                                          });
                                          Fluttertoast.showToast(
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Color.fromRGBO(235, 93, 28, 1),
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                            msg: "Aadhaar Verification Failed",
                                          );
                                        }
                                      },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: aadharFrontWebImage == null ||
                                      aadharBackWebImage == null
                                  ? const Color.fromRGBO(186, 68, 197, 0.4)
                                  : isAadhaarVerified &&
                                          aadharFrontWebImage != null &&
                                          aadharBackWebImage != null
                                      ? const Color.fromRGBO(186, 68, 197, 0.4)
                                      : ColorTheme.purple,
                              padding: EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: Text(
                              isAadhaarVerified &&
                                      aadharFrontWebImage != null &&
                                      aadharBackWebImage != null
                                  ? 'Verified'
                                  : "Verify",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: aadharFrontWebImage == null ||
                                        aadharBackWebImage == null
                                    ? Color.fromRGBO(224, 224, 224, 0.4)
                                    : isAadhaarVerified &&
                                            aadharFrontWebImage != null &&
                                            aadharBackWebImage != null
                                        ? Color.fromRGBO(224, 224, 224, 0.4)
                                        : Color.fromRGBO(225, 225, 225, 1),
                              ),
                            ),
                          ),
                        ),
                        // if (isAadhaarVerified)
                        //   Padding(
                        //     padding: const EdgeInsets.only(left: 23.0),
                        //     child: Row(
                        //       children: [
                        //         const SizedBox(
                        //           height: 30,
                        //         ),
                        //         Text(
                        //           "Aadhar verified successfully",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         const SizedBox(
                        //           width: 10,
                        //         ),
                        //         Image.asset(
                        //           'assets/icons/verified_new.png',
                        //           width: 18,
                        //           height: 18,
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Pan Card",
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: DragAndDrop(
                          onTap: () {
                            uploadImage(3);
                          },
                          webImage: panCardWebImage,
                          text: '',
                          width: 0.39,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: ElevatedButton(
                            onPressed: panCardWebImage == null
                                ? () {
                                    print('1st one');
                                  }
                                : isPanVerified && panCardWebImage != null
                                    ? () {
                                        print('2nd one');
                                      }
                                    : () async {
                                        print('last one');
                                        var response = await apiRepo
                                            .panVerifyCashfree(_panCardFile);
                                        print(response);
                                        if (response != null) {
                                          if (response ==
                                              nameWrapper.toString) {
                                            setState(() {
                                              isPanVerified = true;
                                            });
                                            Fluttertoast.showToast(
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Color.fromRGBO(
                                                  235, 93, 28, 1),
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                              msg:
                                                  "Pan Verification Successful",
                                            );
                                          } else {
                                            setState(() {
                                              isPanVerified = false;
                                              panCardWebImage = null;
                                            });
                                            Fluttertoast.showToast(
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Color.fromRGBO(
                                                  235, 93, 28, 1),
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                              msg: "Pan Verification Failed",
                                            );
                                          }
                                        } else {
                                          setState(() {
                                            isPanVerified = false;
                                            panCardWebImage = null;
                                          });
                                          Fluttertoast.showToast(
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Color.fromRGBO(235, 93, 28, 1),
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                            msg: "Pan Verification Failed",
                                          );
                                        }
                                      },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: panCardWebImage == null
                                  ? const Color.fromRGBO(186, 68, 197, 0.4)
                                  : isPanVerified && panCardWebImage != null
                                      ? const Color.fromRGBO(186, 68, 197, 0.4)
                                      : ColorTheme.purple,
                              padding: EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: Text(
                              isPanVerified && panCardWebImage != null
                                  ? 'Verified'
                                  : "Verify",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: panCardWebImage == null
                                    ? Color.fromRGBO(224, 224, 224, 0.4)
                                    : isPanVerified && panCardWebImage != null
                                        ? Color.fromRGBO(224, 224, 224, 0.4)
                                        : Color.fromRGBO(225, 225, 225, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 25.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(children: [
                  //         DropdownButton<String>(
                  //           value: selectedOption,
                  //           onChanged: (String? newValue) {
                  //             setState(
                  //               () {
                  //                 selectedOption = newValue!;
                  //               },
                  //             );
                  //           },
                  //           items: <String>[
                  //             'Driving licence',
                  //             'Passport',
                  //             'Voters id'
                  //           ].map<DropdownMenuItem<String>>((String value) {
                  //             return DropdownMenuItem<String>(
                  //               value: value,
                  //               child: Center(
                  //                 child: Text(
                  //                   value,
                  //                   style: TextStyle(
                  //                     fontSize: 14,
                  //                     fontWeight: FontWeight.w500,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //             );
                  //           }).toList(),
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 14,
                  //           ),
                  //           dropdownColor: ColorTheme.darkBg,
                  //           underline: Container(),
                  //         ),
                  //         Text(
                  //           "(Optional)",
                  //           style: GoogleFonts.roboto(
                  //             textStyle: TextStyle(
                  //               fontSize: 14,
                  //               fontWeight: FontWeight.w500,
                  //               color: Color.fromRGBO(224, 224, 224, 0.4),
                  //             ),
                  //           ),
                  //         ),
                  //       ]),
                  //       const SizedBox(height: 20),
                  //       DragAndDrop(
                  //         onTap: () {
                  //           uploadImage(4);
                  //         },
                  //         //imagePath: _optionalFile.path,
                  //         webImage: optionalWebImage,
                  //         text: '', width: 0.39,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () async {
                          //Navigator.pushNamed(context, MyRoutes.registrationFace);
                          try {
                            if (!isPhoneNumberVerified) {
                              Fluttertoast.showToast(
                                  msg: "Mobile number is not verified.");
                            } else if (!isEmailVerified) {
                              Fluttertoast.showToast(
                                  msg: "Email is not verified.");
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              String name = nameWrapper.controller.text;
                              String phone = phoneWrapper.controller.text;
                              String email = emailWrapper.controller.text;

                              // Aadhar Verification
                              if (aadharFrontWebImage != null &&
                                  aadharBackWebImage != null) {
                                var aadharVerificationResult =
                                    await apiRepo.aadharVerifyCashfree(
                                  _aadharFrontFile,
                                  _aadharBackFile,
                                );
                                print(
                                    "Aadhar Verification Result: $aadharVerificationResult");
                              } else {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "Aadhar Card not uploaded");
                                return;
                              }

                              // PAN Verification
                              if (panCardWebImage != null) {
                                var panVerificationResult = await apiRepo
                                    .panVerifyCashfree(_panCardFile);
                                print(
                                    "PAN Verification Result: $panVerificationResult");
                              } else {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "Pan Card not uploaded");
                                return;
                              }

                              // API call
                              var result = await apiRepo.register(
                                name,
                                phone,
                                email,
                                _aadharFrontFile,
                                _aadharBackFile,
                                _panCardFile,
                                _optionalFile,
                              );

                              Navigator.pop(context);

                              print(
                                  "--------------------*********************Result********************---------------------");
                              print(result);

                              if (result != null &&
                                  result['status'] == "success") {
                                Navigator.pushNamed(
                                    context, MyRoutes.registrationFace);
                              }
                            }
                          } catch (e) {
                            print(e);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: "Failed to register user",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                          // if(!isPhoneNumberVerified){
                          //   Fluttertoast.showToast(msg: "Mobile number is not verified.");
                          // } else if(!isEmailVerified){
                          //   Fluttertoast.showToast(msg: "Email is not verified.");
                          // }
                          // try {
                          //   showDialog(
                          //     context: context,
                          //     barrierDismissible: false,
                          //     builder: (BuildContext context) {
                          //       return Center(
                          //         child: CircularProgressIndicator(),
                          //       );
                          //     },
                          //   );
                          //   String name = nameWrapper.controller.text;
                          //   String phone = phoneWrapper.controller.text;
                          //   String email = emailWrapper.controller.text;
                          //
                          //   if (_aadharFrontFile != null && _aadharBackFile != null) {
                          //     var aadharVerificationResult = await apiRepo.aadharVerifyCashfree(
                          //     _aadharFrontFile,
                          //     _aadharBackFile,
                          //     );
                          //     print("Aadhar Verification Result: $aadharVerificationResult");
                          //   } else{
                          //     Fluttertoast.showToast(
                          //         msg: "Aadhar Card not uploaded",) ;
                          //   }
                          //
                          //   if (_panCardFile != null) {
                          //     var panVerificationResult = await apiRepo.panVerifyCashfree(_panCardFile);
                          //     print("PAN Verification Result: $panVerificationResult");
                          //   } else{
                          //     Fluttertoast.showToast(
                          //       msg: "Pan Card not uploaded",) ;
                          //   }
                          //
                          //   var result = await apiRepo.register(
                          //     name,
                          //     phone,
                          //     email,
                          //     _aadharFrontFile,
                          //     _aadharBackFile,
                          //     _panCardFile,
                          //     _optionalFile,
                          //   );
                          //   Navigator.pop(context);
                          //
                          //   print(
                          //       "--------------------*********************Result********************---------------------");
                          //   print(result);
                          //   if (result != null &&
                          //       result['status'] == "success") {
                          //     Navigator.pushNamed(
                          //         context, MyRoutes.registrationFace);
                          //   }
                          // } catch (e) {
                          //   print(e);
                          //   Navigator.pop(context);
                          //   Fluttertoast.showToast(
                          //     msg: "Failed to register user",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.CENTER,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.red,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0,
                          //   );
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: ColorTheme.purple,
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(224, 224, 224, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              );
            } else {
              //PC
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Registration Details",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      //Full name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Name  ",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "(as per Aadhaar)",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(255, 255, 255, 0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: size.width * 0.228,
                            child: CustomTextField(
                                wrapper: nameWrapper,
                                hintText: "Enter your full name"),
                          ),
                        ],
                      ),
                      SizedBox(width: size.width * 0.04),
                      //Phone Number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone Number",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: size.width * 0.228,
                                child: CustomTextField(
                                  wrapper: phoneWrapper,
                                  hintText: "Enter your phone number",
                                  focusNode: _numberFocus,
                                  onFocusChanged: () {
                                    _handleFocusChange();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () async {
                                    await sendMobileOTP();
                                  },
                                  child: Text(
                                    'Send OTP',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: size.width * 0.04),
                      //Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email address",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: size.width * 0.228,
                                child: CustomTextField(
                                  wrapper: emailWrapper,
                                  hintText: "Enter your email ID",
                                  focusNode: _emailFocus,
                                  onFocusChanged: () {
                                    _handleFocusChange();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () async {
                                    await sendEmailOTP();
                                  },
                                  child: Text(
                                    'Send OTP',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //OTP Wrappers
                  Row(
                    children: [
                      //Blank
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: size.width * 0.228,
                          ),
                        ],
                      ),
                      SizedBox(width: size.width * 0.04),
                      //Phone Number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter OTP",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MobileOtpSent
                                    ? Color.fromRGBO(224, 224, 224, 1)
                                    : Color.fromRGBO(224, 224, 224, 0.4),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: size.width * 0.228,
                                child: CustomTextField(
                                  wrapper: mobileOTPWrapper,
                                  hintText: "Enter OTP",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await verifyMobileOTP();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: MobileOtpSent
                                        ? ColorTheme.purple
                                        : const Color.fromRGBO(
                                            186, 68, 197, 0.4),
                                    padding: EdgeInsets.all(16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Verify",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: MobileOtpSent
                                          ? Color.fromRGBO(224, 224, 224, 1)
                                          : Color.fromRGBO(224, 224, 224, 0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isPhoneNumberVerified)
                            Row(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Phone number verified successfully",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  'assets/icons/verified_new.png',
                                  width: 18,
                                  height: 18,
                                )
                              ],
                            ),
                        ],
                      ),
                      SizedBox(width: size.width * 0.04),
                      //Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter OTP",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: EmailOtpSent
                                    ? Color.fromRGBO(224, 224, 224, 1)
                                    : Color.fromRGBO(224, 224, 224, 0.4),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: size.width * 0.228,
                                child: CustomTextField(
                                  wrapper: emailOTPWrapper,
                                  hintText: "Enter OTP",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await verifyEmailOTP();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: EmailOtpSent
                                        ? ColorTheme.purple
                                        : const Color.fromRGBO(
                                            186, 68, 197, 0.4),
                                    padding: EdgeInsets.all(16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Verify",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: EmailOtpSent
                                          ? Color.fromRGBO(224, 224, 224, 1)
                                          : Color.fromRGBO(224, 224, 224, 0.4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isEmailVerified)
                            Row(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Email verified successfully",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  'assets/icons/verified_new.png',
                                  width: 18,
                                  height: 18,
                                )
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Aadhaar Card",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              DragAndDrop(
                                onTap: () {
                                  uploadImage(1);
                                  //print('Aadhafrontwebimage : $aadharFrontWebImage');
                                },
                                //imagePath: _aadharFrontFile.path
                                webImage: aadharFrontWebImage,
                                text: '(Front Side)', width: 0.16,
                              ),
                              const SizedBox(width: 30),
                              DragAndDrop(
                                onTap: () {
                                  uploadImage(2);
                                  //print('Aadhafrontbackimage : $aadharBackWebImage');
                                },
                                //imagePath: _aadharBackFile.path,
                                webImage: aadharBackWebImage,
                                text: '(Back Side)', width: 0.16,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Enter OTP",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: EmailOtpSent
                                    ? Color.fromRGBO(224, 224, 224, 1)
                                    : Color.fromRGBO(224, 224, 224, 0.4),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                width: size.width * 0.228,
                                child: CustomTextField(
                                  wrapper: aadharOTPWrapper,
                                  hintText: "Enter OTP",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AadharOtpSent
                                        ? ColorTheme.purple
                                        : const Color.fromRGBO(
                                            186, 68, 197, 0.4),
                                    padding: EdgeInsets.all(16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Verify",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AadharOtpSent
                                          ? Color.fromRGBO(224, 224, 224, 1)
                                          : Color.fromRGBO(224, 224, 224, 0.4),
                                    ),
                                  ),
                                ),
                              ),
                              if (isAadhaarVerified)
                                Row(
                                  children: [
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Aadhar verified successfully",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      'assets/icons/verified_new.png',
                                      width: 18,
                                      height: 18,
                                    )
                                  ],
                                ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: size.width * 0.26,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "PanCard",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DragAndDrop(
                            onTap: () {
                              uploadImage(3);
                            },
                            //imagePath: _panCardFile.path,
                            webImage: panCardWebImage,
                            text: '', width: 0.16,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // DropdownButton<String>(
                  //   value: selectedOption,
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       selectedOption = newValue!;
                  //     });
                  //   },
                  //   items: <String>['Driving licence', 'Passport', 'Voters id']
                  //       .map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Center(
                  //         child: Text(
                  //           value,
                  //           style: GoogleFonts.mulish(
                  //             textStyle: TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.bold,
                  //               color: selectedOption == value
                  //                   ? Colors.white
                  //                   : Colors.black87,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  // const SizedBox(height: 20),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       DragAndDrop(
                  //         onTap: () {
                  //           uploadImage(4);
                  //         },
                  //         //imagePath: _optionalFile.path,
                  //         webImage: optionalWebImage,
                  //         text: 'Front Page', width: 0.23,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Center(
                    child: SizedBox(
                      width: size.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, MyRoutes.home);
                          try {
                            if (!isPhoneNumberVerified) {
                              Fluttertoast.showToast(
                                  msg: "Mobile number is not verified.");
                            } else if (!isEmailVerified) {
                              Fluttertoast.showToast(
                                  msg: "Email is not verified.");
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              String name = nameWrapper.controller.text;
                              String phone = phoneWrapper.controller.text;
                              String email = emailWrapper.controller.text;

                              // Aadhar Verification
                              if (aadharFrontWebImage != null &&
                                  aadharBackWebImage != null) {
                                var aadharVerificationResult =
                                    await apiRepo.aadharVerifyCashfree(
                                  _aadharFrontFile,
                                  _aadharBackFile,
                                );
                                print(
                                    "Aadhar Verification Result: $aadharVerificationResult");
                              } else {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "Aadhar Card not uploaded");
                                return;
                              }

                              // PAN Verification
                              if (panCardWebImage != null) {
                                var panVerificationResult = await apiRepo
                                    .panVerifyCashfree(_panCardFile);
                                print(
                                    "PAN Verification Result: $panVerificationResult");
                              } else {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "Pan Card not uploaded");
                                return;
                              }

                              // API call
                              var result = await apiRepo.register(
                                name,
                                phone,
                                email,
                                _aadharFrontFile,
                                _aadharBackFile,
                                _panCardFile,
                                _optionalFile,
                              );

                              Navigator.pop(context);

                              print(
                                  "--------------------*********************Result********************---------------------");
                              print(result);

                              if (result != null &&
                                  result['status'] == "success") {
                                Navigator.pushNamed(
                                    context, MyRoutes.registrationFace);
                              }
                            }
                          } catch (e) {
                            print(e);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                              msg: "Failed to register user",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                          // try {
                          //   showDialog(
                          //     context: context,
                          //     barrierDismissible: false,
                          //     builder: (BuildContext context) {
                          //       return Center(
                          //         child: CircularProgressIndicator(),
                          //       );
                          //     },
                          //   );
                          //   String name = nameWrapper.controller.text;
                          //   String phone = phoneWrapper.controller.text;
                          //   String email = emailWrapper.controller.text;
                          //
                          //   var result = await apiRepo.register(
                          //     name,
                          //     phone,
                          //     email,
                          //     _aadharFrontFile,
                          //     _aadharBackFile,
                          //     _panCardFile,
                          //     _optionalFile,
                          //   );
                          //   Navigator.pop(context);
                          //
                          //   print(
                          //       "--------------------*********************Result********************---------------------");
                          //   print(result);
                          //   if (result != null && result['status'] == "success") {
                          //     Navigator.pushNamed(
                          //         context, MyRoutes.registrationFace);
                          //   }
                          // } catch (e) {
                          //   print(e);
                          //   Navigator.pop(context);
                          //   Fluttertoast.showToast(
                          //     msg: "Failed to register user",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.CENTER,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.red,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0,
                          //   );
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: ColorTheme.purple,
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text("Register"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  void _handleFocusChange() {
    setState(() {});
  }

  uploadImage(int fileIndex) async {
    html.FileUploadInputElement upLoadInput = html.FileUploadInputElement();
    upLoadInput.multiple = true;
    upLoadInput.draggable = true;
    upLoadInput.click();

    await upLoadInput.onChange.first;

    final files = upLoadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];

      final reader = html.FileReader();

      print("Selected File Name: ${file.name}");

      reader.onLoadEnd.listen((event) async {
        final result = reader.result as String;
        final base64Data = result.split(",").last;
        final bytesData = Base64Decoder().convert(base64Data);

        setState(() {
          _bytesData = bytesData;
          //print('fileindex: $fileIndex\n $_bytesData');
          //_selectedFile = _bytesData;
          if (fileIndex == 1) {
            aadharFrontWebImage = _bytesData;
            _aadharFrontFile = file;
          } else if (fileIndex == 2) {
            aadharBackWebImage = _bytesData;
            _aadharBackFile = file;
          } else if (fileIndex == 3) {
            panCardWebImage = _bytesData;
            _panCardFile = file;
          } else if (fileIndex == 4) {
            optionalWebImage = _bytesData;
            _optionalFile = file;
          } else {
            Fluttertoast.showToast(
              msg: "No file selected",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        });
      });
      reader.readAsDataUrl(file);
    }
  }

  Future<void> sendMobileOTP() async {
    String mobileNo = phoneWrapper.controller.text;
    print(mobileNo);
    try {
      print("inside try");
      var response = await apiRepo.sendMobileOtp(mobileNo);
      print(response);
      if (response != null && response['status'] == 'success') {
        Fluttertoast.showToast(
          msg: 'OTP sent successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        setState(() {
          MobileOtpSent = true;
        });
      } else {
        print('Failed to send OTP');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> verifyMobileOTP() async {
    String mobileNo = phoneWrapper.controller.text;
    String otp = mobileOTPWrapper.controller.text;
    try {
      var response = await apiRepo.verifyMobileOtp(mobileNo, otp);
      print(response);
      if (response != null && response['status'] == 'success') {
        Fluttertoast.showToast(
          msg: 'OTP verified successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        setState(() {
          isPhoneNumberVerified = true;
        });
      } else {
        print('Failed to verify OTP');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> sendEmailOTP() async {
    String email = emailWrapper.controller.text;
    print(email);
    try {
      print("inside try");
      var response = await apiRepo.sendEmailOtp(email);
      print(response);
      if (response != null && response['status'] == 'success') {
        Fluttertoast.showToast(
          msg: 'OTP sent successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        setState(() {
          EmailOtpSent = true;
        });
      } else {
        print('Failed to send OTP');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> verifyEmailOTP() async {
    String email = emailWrapper.controller.text;
    String otp = emailOTPWrapper.controller.text;
    try {
      var response = await apiRepo.verifyEmailOtp(email, otp);
      print(response);
      if (response != null && response['status'] == 'success') {
        Fluttertoast.showToast(
          msg: 'OTP verified successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        setState(() {
          isEmailVerified = true;
        });
      } else {
        print('Failed to verify OTP');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> panVerify() async {
    String refId = "";
    print("Inside pan verify");
    try {
      var response = await apiRepo.panVerifyCashfree(_panCardFile);
      print(response);

      if (response == nameWrapper.toString) {
        setState(() {
          isPanVerified = true;
        });
      }

      // if (response != null && response['responseCode'] == 'SRS016') {
      // refId = response['data']['referenceId'];
      // print(refId);

      // //Reference id verify API
      // try {
      //   var response2 = await apiRepo.panVerifyRef(refId);
      //   print(response2);
      //   if (response != null && response['responseCode'] == 'SRS001') {
      //     print("Successfull");
      //   }
      //   } catch (error) {
      //   print('Error: $error');
      // }

      // } else {
      //   print('Failed');
      // }
    } catch (error) {
      print('Error: $error');
    }
  }

  void pickFiles(int fileIndex) async {
    List<PlatformFile>? _paths;

    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      if (_paths != null && _paths.isNotEmpty) {
        final file = _paths[0];

        final reader = html.FileReader();

        print("Selected File Name: ${file.name}");

        reader.onLoadEnd.listen((event) async {
          final result = reader.result as String;
          final base64Data = result.split(",").last;
          final bytesData = Base64Decoder().convert(base64Data);

          setState(() {
            _bytesData = bytesData;
            //print('fileindex: $fileIndex\n $_bytesData');
            //_selectedFile = _bytesData;
            if (fileIndex == 1) {
              aadharFrontWebImage = _bytesData;
              _aadharFrontFile = file as html.File;
            } else if (fileIndex == 2) {
              aadharBackWebImage = _bytesData;
              _aadharBackFile = file as html.File;
            } else if (fileIndex == 3) {
              panCardWebImage = _bytesData;
              _panCardFile = file as html.File;
            } else if (fileIndex == 4) {
              optionalWebImage = _bytesData;
              _optionalFile = file as html.File;
            } else {
              Fluttertoast.showToast(
                msg: "No file selected",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        });
        //reader.readAsDataUrl(File.fromUri(Uri.parse(file.path)));
      }
    });
  }
}
