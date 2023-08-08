import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/color_utils.dart';

class admin_login extends StatefulWidget {
  const admin_login({super.key});

  @override
  State<admin_login> createState() => _admin_loginState();
}

class _admin_loginState extends State<admin_login> {
  var phone = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("9E6F21"),
            hexStringToColor("57C5B6")
          ])),
          child: Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/admin_login__.png'),
                  // Text(
                  //   "Phone Verification",
                  //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Text(
                    "Login to Admin's Account",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              phone = value;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Full number'),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              phone = value;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter police domain email'),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (value) {
                              phone = value;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter password'),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: hexStringToColor('#F2FCFF'),
                            onPrimary: Colors.black,
                            minimumSize: Size(double.infinity, 40)),
                        icon: FaIcon(FontAwesomeIcons.peopleGroup),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "home_page", (route) => false);
                        },
                        label: Text(
                          "Be an Authorized User",
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "OR",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: hexStringToColor('#F2FCFF'),
                            onPrimary: Colors.black,
                            minimumSize: Size(double.infinity, 40)),
                        icon: FaIcon(FontAwesomeIcons.arrowLeft),
                        onPressed: () {
                          Navigator.pushNamed(context, "admin_login");
                        },
                        label: Text(
                          "Try other ways",
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
