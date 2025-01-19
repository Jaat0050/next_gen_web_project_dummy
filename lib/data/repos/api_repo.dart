import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import '../../shared_pref_helper.dart';
import '../../views/models/Users.dart';
import '../../views/models/InActiveUser.dart';

class ApiRepo {
  static List<String> url = [
    "https://bkb-nodejs.vercel.app",
    "https://localhost:5000",
  ];
  static int isbeta = 0;

  //User
  String registerUrl = "${url[isbeta]}/api/user/upload-user";
  String fetchAccountStatusUrl = "${url[isbeta]}/api/user/fetch-user-account-status";

  //String userLoginUrl = "${url[isbeta]}/api/user/login-with-mobileNumber";
  String userLoginUrl = "https://face-ml.seedmount.tech/login";
  String sendMobileOtpUrl = "${url[isbeta]}/api/user/send-otp";
  String verifyMobileOtpUrl = "${url[isbeta]}/api/user/verify-otp";
  String sendEmailOtpUrl = "${url[isbeta]}/api/user/send-otp-for-email";
  String verifyEmailOtpUrl = "${url[isbeta]}/api/user/verify-email";

  //Pan and Aadhar
  String Url = "https://sm-kyc-sync-sandbox.scoreme.in/kyc/external/documentuploadrequest";
  String refUrl = "https://sm-kyc-sync-sandbox.scoreme.in/kyc/external/getDocumentData?referenceId=";

  String cashfreeUrlAadhaar = "https://api.cashfree.com/verification/document/aadhaar";
  String cashfreeUrlPan = "https://api.cashfree.com/verification/document/pan";

  //Admin
  String adminLoginUrl = "${url[isbeta]}/api/admin/login";
  String getAllInActiveUsersUrl = "${url[isbeta]}/api/admin/inactive-user";
  String getAllActiveUsersUrl = "${url[isbeta]}/api/admin/active-user";
  String changeStatusUrl = "${url[isbeta]}/api/admin/account-status-change";
  String rejectedUrl = "${url[isbeta]}/api/user/reject-user";

  //--------------------------------------------------------------------------User Registration--------------------------------------------------

  Future<dynamic> register(
    String name,
    String number,
    String email,
    html.File adharFront,
    html.File adharBack,
    html.File panFront,
    html.File others,
  ) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(registerUrl));

      print("Inside api call");

      request.fields['name'] = name;
      request.fields['mobileNumber'] = number;
      request.fields['email'] = email;
      // request.fields['password'] = 'rahul@123';
      // request.fields['isActive'] = 'false';

      // Read file content as bytes
      var adharFrontBytes = await readFileAsBytes(adharFront);
      var adharBackBytes = await readFileAsBytes(adharBack);
      var panFrontBytes = await readFileAsBytes(panFront);
      var othersBytes = await readFileAsBytes(others);

      // Add files
      request.files.add(http.MultipartFile(
        'adharFront',
        http.ByteStream.fromBytes(adharFrontBytes),
        adharFrontBytes.length,
        filename: 'adharFront.jpg',
      ));
      request.files.add(http.MultipartFile(
        'adharBack',
        http.ByteStream.fromBytes(adharBackBytes),
        adharBackBytes.length,
        filename: 'adharBack.jpg',
      ));
      request.files.add(http.MultipartFile(
        'panFront',
        http.ByteStream.fromBytes(panFrontBytes),
        panFrontBytes.length,
        filename: 'panFront.jpg',
      ));
      // request.files.add(http.MultipartFile(
      //   'others',
      //   http.ByteStream.fromBytes(othersBytes),
      //   panFrontBytes.length,
      //   filename: 'other.jpg',
      // ));

      // Send the request
      var response = await http.Response.fromStream(await request.send());
      print("This is the response");
      print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        String userId = responseBody['data'][0]['_id'];
        print('user_id');
        await SharedPreferencesHelper.init();
        await SharedPreferencesHelper.saveUserDetails(name, number, email, userId);

        html.window.localStorage['name'] = name;
        html.window.localStorage['number'] = number;
        html.window.localStorage['email'] = email;

        return responseBody;
      } else {
        throw "Failed to Register User";
      }
    } catch (e) {
      print(e);
      throw "Failed to Register User";
    }
  }

  Future<List<int>> readFileAsBytes(html.File file) async {
    var completer = Completer<List<int>>();
    var reader = html.FileReader();

    reader.onLoad.listen((event) {
      var result = reader.result;
      if (result is List<int>) {
        completer.complete(result);
      } else {
        completer.completeError("Failed to read file as bytes.");
      }
    });

    reader.onError.listen((event) {
      completer.completeError("Error reading file: ${reader.error}");
    });

    reader.readAsArrayBuffer(file);
    return completer.future;
  }

//-------------------------------------------------------------------Face Authentication --------------------------------------------------

  Future<dynamic> faceAuth(String name, String userId, html.File image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('https://face-ml.seedmount.tech/register'));

      request.fields['name'] = name;
      request.fields['user_id'] = userId;
      request.headers['Content-Type'] = 'multipart/form-data';

      var imageBytes = await readFileAsBytes(image);

      request.files.add(http.MultipartFile(
        'images[]',
        http.ByteStream.fromBytes(imageBytes),
        imageBytes.length,
        filename: 'image.jpg',
      ));

      print('Inside the api call');

      var response = await http.Response.fromStream(await request.send());
      print("Response");
      print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  //--------------------------------------------------------------------------User Login--------------------------------------------------
  //
  // Future<dynamic> userLogin(String mobileNumber) async {
  //   try {
  //     var response = await http.post(
  //       Uri.parse(userLoginUrl),
  //       body: {
  //         'mobileNumber': mobileNumber,
  //       },
  //     );
  //
  //     print("----------------Response body-----------------");
  //     print(response.body);
  //
  //     if (response.statusCode == 200) {
  //       var responseBody = json.decode(response.body);
  //
  //       //for storing session
  //       html.window.localStorage['number'] = responseBody['data'][0]['mobileNumber'];
  //       html.window.localStorage['isActive'] = responseBody['data'][0]['isActive'].toString();
  //       print( responseBody['data'][0]['isActive']);
  //       return responseBody;
  //     } else {
  //       throw "Failed to Login";
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw "Failed to Login";
  //   }
  // }

  Future<dynamic> userLogin(html.File image) async {
    try {
      print('Inside the userLogin function');

      var imageBytes = await readFileAsBytes(image);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(userLoginUrl),
      );

      request.files.add(http.MultipartFile(
        'image',
        http.ByteStream.fromBytes(imageBytes),
        imageBytes.length,
        filename: 'image.jpg',
      ));

      var response = await http.Response.fromStream(await request.send());

      print("----------------Response body-----------------");
      print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print(responseBody['status']);
        return responseBody;
      } else {
        throw "Failed to Login";
      }
    } catch (e) {
      print('Error: $e');
      throw "Failed to Login";
    }
  }

  //--------------------------------------------------------------------------Send Mobile Otp--------------------------------------------------

  Future<dynamic> sendMobileOtp(String mobile) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$sendMobileOtpUrl?mobile=$mobile&signature=dfsdf'),
      );
      print('$sendMobileOtpUrl?mobile=$mobile&signature=dfsdf');
      print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception('Failed to send OTP. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  //--------------------------------------------------------------------------Verify Mobile Otp--------------------------------------------------

  Future<dynamic> verifyMobileOtp(String mobile, String otp) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$verifyMobileOtpUrl?mobile=$mobile&otp=$otp'),
      );
      print('$verifyMobileOtpUrl?mobile=$mobile&otp=$otp');
      print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception('Failed to verify OTP. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  //--------------------------------------------------------------------------Send Email Otp--------------------------------------------------

  Future<dynamic> sendEmailOtp(String email) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$sendEmailOtpUrl'),
        body: {
          'email': email,
        },
      );

//     print('$sendEmailOtpUrl?email=$email');
      print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception('Failed to send OTP. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  //--------------------------------------------------------------------------Verify Email Otp--------------------------------------------------

  Future<dynamic> verifyEmailOtp(String email, String otp) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$verifyEmailOtpUrl?email=$email&otp=$otp'),
      );
      print('$verifyEmailOtpUrl?email=$email&otp=$otp');
      print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception('Failed to verify OTP. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  //-----------------------------------------------------------------------Admin Login--------------------------------------------------

  Future<dynamic> adminLogin(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse(adminLoginUrl),
        body: {
          'email': email,
          'password': password,
        },
      );

      print("----------------Response body-----------------");
      print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var token = responseBody['data'][0]['token'];
        html.window.localStorage['token'] = token;
        //print(token);
        return responseBody;
      } else {
        throw "Failed to Login";
      }
    } catch (e) {
      print(e);
      throw "Failed to Login";
    }
  }

  //-------------------------------------------------------------------List of Active Users--------------------------------------------------

  Future<List<User>> fetchActiveUsers() async {
    final response = await http.get(Uri.parse(getAllActiveUsersUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load active users');
    }
  }

  //-------------------------------------------------------------------List of InActive Users--------------------------------------------------

  Future<List<InActiveUser>> fetchInActiveUsers() async {
    final response = await http.get(Uri.parse(getAllInActiveUsersUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((item) => InActiveUser.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load active users');
    }
  }

  //-------------------------------------------------------------------Change Account Status --------------------------------------------------

  Future<dynamic> changeAccountStatus(String id) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$changeStatusUrl?userId=$id'),
      );
      print('$changeStatusUrl?userId=$id');
      print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception('Failed to change account status. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  //-------------------------------------------------------------------Fetch Account Status --------------------------------------------------

  Future<dynamic> fetchAccountStatus(String userId) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$fetchAccountStatusUrl?userId=$userId'),
      );
      print("inside fetch");
      print('$fetchAccountStatusUrl?userId=$userId');
      print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception("Couldn't fetch account status. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  //------------------------------------------------------------------Reject --------------------------------------------------

  Future<dynamic> reject(String id) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$rejectedUrl?userId=$id'),
      );
      print('$rejectedUrl?userId=$id');
      print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        return responseBody;
      } else {
        throw Exception('Error occurred. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  //scoreme

  //------------------------------------------------------------------Aadhar verify --------------------------------------------------

  Future<dynamic> aadharVerify(html.File aadharFront, html.File aadharBack) async {
    try {
      print('Inside the Aadhar verify function');
      print(aadharFront);
      print(aadharBack);

      var aadharFrontBytes = await readFileAsBytes(aadharFront);
      var aadharBackBytes = await readFileAsBytes(aadharBack);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Url),
      );

      request.headers.addAll({
        'clientId': "ee2618035f5ab074bb930f9ce583aaea",
        'clientSecret': "cd26c2d0c7d3c9e02709fdbca5fb6fcb39634b32f979a2c29650d673a20c7aea",
      });

      request.files.add(http.MultipartFile(
        'files',
        http.ByteStream.fromBytes(aadharFrontBytes),
        aadharFrontBytes.length,
        filename: 'aadharFront.jpeg',
      ));

      request.files.add(http.MultipartFile(
        'files',
        http.ByteStream.fromBytes(aadharBackBytes),
        aadharBackBytes.length,
        filename: 'aadharBack.jpeg',
      ));

      request.fields['payload'] = '{"documentType":"aadhaar"}';
      var response = await http.Response.fromStream(await request.send());

      print('$Url');
      //print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print(responseBody);
        if (responseBody != null && responseBody['responseCode'] == 'SRS016') {
          String refId = responseBody['data']['referenceId'];
          print(refId);

          //Reference id verify API
          try {
            var response2 = await aadharVerifyRef(refId);
            print(response2);
            if (response2 != null && response2['responseCode'] == 'SRS001') {
              print("Successful");
            }
          } catch (error) {
            print('Error: $error');
          }
        } else {
          print('Failed');
        }
        return responseBody;
      } else {
        throw Exception('Error occurred. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in aadharVerify: $error');
      throw error;
    }
  }

  Future<dynamic> aadharVerifyRef(String refId) async {
    try {
      print('Inside the Aadhar verify Ref function');

      final http.Response response = await http.get(
        Uri.parse('$refUrl$refId'),
        headers: {
          'clientId': "ee2618035f5ab074bb930f9ce583aaea",
          'clientSecret': "cd26c2d0c7d3c9e02709fdbca5fb6fcb39634b32f979a2c29650d673a20c7aea",
        },
      );
      print('$refUrl$refId');
      //print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print(responseBody);
        return responseBody;
      } else {
        throw Exception('Error occurred. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in aadharVerifyRef: $error');
      throw error;
    }
  }

  //------------------------------------------------------------------Pan verify --------------------------------------------------

  Future<dynamic> panVerify(html.File image) async {
    try {
      print('Inside the Pan verify function');
      print(image);

      var imageBytes = await readFileAsBytes(image);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Url),
      );

      request.headers.addAll({
        'clientId': "ee2618035f5ab074bb930f9ce583aaea",
        'clientSecret': "cd26c2d0c7d3c9e02709fdbca5fb6fcb39634b32f979a2c29650d673a20c7aea",
        'Accept': "*/*",
        'Content-Type': 'multipart/form-data',
      });

      request.files.add(http.MultipartFile(
        'files',
        http.ByteStream.fromBytes(imageBytes),
        imageBytes.length,
        filename: 'image.jpeg',
      ));

      request.fields['payload'] = '{"documentType":"individualPan"}';
      var response = await http.Response.fromStream(await request.send());

      print('$Url');
      //print(response.body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print(responseBody);
        // if (responseBody != null && responseBody['responseCode'] == 'SRS016') {
        //   String refId = responseBody['data']['referenceId'];
        //   print(refId);
        //
        //   //Reference id verify API
        //   try {
        //     var response2 = await panVerifyRef(refId);
        //     print(response2);
        //     if (response2 != null && response2['responseCode'] == 'SRS001') {
        //       print("Successful");
        //     }
        //   } catch (error) {
        //     print('Error: $error');
        //   }
        // } else {
        //   print('Failed');
        // }
        return responseBody;
      } else {
        throw Exception('Error occurred. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in panVerify: $error');
      throw error;
    }
  }

  Future<dynamic> panVerifyRef(String refId) async {
    try {
      print('Inside the Pan verify Ref function');

      final http.Response response = await http.get(
        Uri.parse('$refUrl"db34a8e2-62dc-49c9-8b1a-04e042dd5e86'),
        headers: {
          'clientId': "ee2618035f5ab074bb930f9ce583aaea",
          'clientSecret': "cd26c2d0c7d3c9e02709fdbca5fb6fcb39634b32f979a2c29650d673a20c7aea",
          'Accept': "*/*",
        },
      );
      print('$refUrl$refId');
      //print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print(responseBody);
        return responseBody;
      } else {
        throw Exception('Error occurred. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in panVerifyRef: $error');
      throw error;
    }
  }

//Cashfree

//------------------------------------------------------------------Aadhar verify --------------------------------------------------------------

  Future<dynamic> aadharVerifyCashfree(html.File aadharFront, html.File aadharBack) async {
    try {
      print('Inside the Aadhar verify function');
      print(aadharFront);
      print(aadharBack);

      var aadharFrontBytes = await readFileAsBytes(aadharFront);
      var aadharBackBytes = await readFileAsBytes(aadharBack);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(cashfreeUrlAadhaar),
      );

      request.headers.addAll({
        'Content-Type': "multipart/form-data",
        'clientId': "",
        'clientSecret': "",
      });

      request.files.add(http.MultipartFile(
        'front_image',
        http.ByteStream.fromBytes(aadharFrontBytes),
        aadharFrontBytes.length,
        filename: 'front_image.jpeg',
      ));

      request.files.add(http.MultipartFile(
        'back_image',
        http.ByteStream.fromBytes(aadharBackBytes),
        aadharBackBytes.length,
        filename: 'back_image.jpeg',
      ));

      request.fields['verification_id'] = 'dwdwqdqwdwqdcdscvarfwae';

      var response = await http.Response.fromStream(await request.send());

      print('$Url');
      //print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print(responseBody);
        return responseBody;
      } else {
        throw Exception('Error occurred. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

//------------------------------------------------------------------Pan verify --------------------------------------------------------------

  Future<dynamic> panVerifyCashfree(html.File panCard) async {
    try {
      print('Inside the Pan verify function');
      print(panCard);

      var panCardBytes = await readFileAsBytes(panCard);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(cashfreeUrlPan),
      );

      request.headers.addAll({
        'Content-Type': "multipart/form-data",
        'x-client-id': "",
        'x-client-secret': "",
      });

      request.files.add(http.MultipartFile(
        'front_image',
        http.ByteStream.fromBytes(panCardBytes),
        panCardBytes.length,
        filename: 'panCard.jpeg',
      ));

      request.fields['verification_id'] = DateTime.now().millisecondsSinceEpoch.toString();

      print('Request URI: ${request.url}');
      print('Request Headers: ${request.headers}');
      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files}');

      var response = await http.Response.fromStream(await request.send());

      print('$Url');
      print(response.body);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);

        if (responseBody['message'] == 'PAN card is valid') {
          // Extract and return the 'name' field
          String name = responseBody['name'];
          print('$name');
          return name;
        } else {
          throw Exception('PAN card verification failed: ${responseBody['message']}');
        }
      } else {
        throw Exception('Error occurred. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }
}

// cfsk_
// ma_
// prod_
// b8a283142a690733c981910f2ff4d013_
// 07afc51d

// CF186285CMAPE
// QAEL4KONMO339FG