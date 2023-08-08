import 'package:citisers/utils/color_utils.dart';
import 'package:citisers/services/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class number_page extends StatefulWidget {
  const number_page({super.key});

  static String verify = "";

  @override
  State<number_page> createState() => _number_pageState();
}

class _number_pageState extends State<number_page> {
  TextEditingController countrycode = TextEditingController();
  var phone = "";

  @override
  void initState() {
    countrycode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("c88d2a"),
            hexStringToColor("7dd2c6")
          ])),
          child: Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/number_page.png'),
                  SizedBox(
                    height: 10,
                  ),
                  // Text(
                  //   "Phone Verification",
                  //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Register your phone to get started",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       border: Border.all(width: 1),
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.white),
                  //   child: Row(
                  //     children: [
                  //       SizedBox(
                  //         width: 8,
                  //       ),
                  //       SizedBox(
                  //         width: 35,
                  //         child: TextField(
                  //           controller: countrycode,
                  //           textAlign: TextAlign.center,
                  //           textAlignVertical: TextAlignVertical.center,
                  //           decoration: InputDecoration(
                  //             border: InputBorder.none,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         '|',
                  //         style: TextStyle(
                  //           fontSize: 40,
                  //           fontWeight: FontWeight.w100,
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: TextField(
                  //           keyboardType: TextInputType.phone,
                  //           onChanged: (value) {
                  //             phone = value;
                  //           },
                  //           decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //               hintText: 'Enter phone number'),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           primary: hexStringToColor('#F2FCFF'),
                  //           onPrimary: Colors.black,
                  //           minimumSize: Size(double.infinity, 40)),
                  //       onPressed: () async {
                  //         await FirebaseAuth.instance.verifyPhoneNumber(
                  //           phoneNumber: '${countrycode.text + phone}',
                  //           verificationCompleted:
                  //               (PhoneAuthCredential credential) {},
                  //           verificationFailed: (FirebaseAuthException e) {},
                  //           codeSent:
                  //               (String verificationId, int? resendToken) {
                  //             number_page.verify = verificationId;
                  //             Navigator.pushNamed(context, "otp_page");
                  //           },
                  //           codeAutoRetrievalTimeout:
                  //               (String verificationId) {},
                  //         );
                  //         // Navigator.pushNamed(context, "otp_page");
                  //       },
                  //       child: Text(
                  //         "Send Verification Code",
                  //       )),
                  // // ),
                  // SizedBox(
                  //   height: 5,
                  // ),

                  // Text(
                  //   "OR",
                  //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  //   textAlign: TextAlign.center,
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: hexStringToColor('#F2FCFF'),
                            onPrimary: Colors.black,
                            minimumSize: Size(double.infinity, 40)),
                        icon: FaIcon(FontAwesomeIcons.google),
                        onPressed: () async {
                          await FirebaseServices().signInWithGoogle();

                          Navigator.pushNamedAndRemoveUntil(
                              context, "home_page", (route) => false);
                        },
                        label: Text(
                          "Sign Up with Google",
                        )),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),

                  // Text(
                  //   "OR",
                  //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  //   textAlign: TextAlign.center,
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // ElevatedButton.icon(
                  //     style: ElevatedButton.styleFrom(
                  //         primary: hexStringToColor('#F2FCFF'),
                  //         onPrimary: Colors.black,
                  //         minimumSize: Size(double.infinity, 40)),
                  //     icon: FaIcon(FontAwesomeIcons.addressCard),
                  //     onPressed: () {
                  //       Navigator.pushNamed(context, "admin_login");
                  //     },
                  //     label: Text(
                  //       "Admin's Sign In",
                  //     )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
