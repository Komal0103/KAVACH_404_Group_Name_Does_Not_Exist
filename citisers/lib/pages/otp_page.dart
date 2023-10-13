import 'package:citisers/pages/number_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pinput.dart';

import '../utils/color_utils.dart';

class otp_page extends StatefulWidget {
  const otp_page({super.key});

  @override
  State<otp_page> createState() => _otp_pageState();
}

class _otp_pageState extends State<otp_page> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    // ignore: unused_local_variable
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    // ignore: unused_local_variable
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code = "";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "number_page");
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("9E6F21"),
          hexStringToColor("57C5B6")
        ])),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/otp_page.png'),
                Text(
                  "Phone Verification",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Register your phone to get started",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Pinput(
                  length: 6,
                  showCursor: true,
                  onChanged: (value) {
                    code = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: hexStringToColor('#F2FCFF'),
                          onPrimary: Colors.black,
                          minimumSize: Size(double.infinity, 40)),
                      onPressed: () async {
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: number_page.verify,
                                  smsCode: code);
                          await auth.signInWithCredential(credential);
                          Navigator.pushNamedAndRemoveUntil(
                              context, 'home_page', (route) => false);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text("Verify Code")),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "OR",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: hexStringToColor('#F2FCFF'),
                        onPrimary: Colors.black,
                        minimumSize: Size(double.infinity, 40)),
                    icon: FaIcon(FontAwesomeIcons.phone),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "number_page", (route) => false);
                    },
                    label: Text(
                      "Try other ways",
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
