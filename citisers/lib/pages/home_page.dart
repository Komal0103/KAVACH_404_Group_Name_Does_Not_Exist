// import 'package:citisers/google_sign_in.dart';
import 'package:citisers/pages/number_page.dart';
import 'package:citisers/utils/color_utils.dart';
import 'package:citisers/utils/round_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imageview360/imageview360.dart';
import 'package:marquee/marquee.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<AssetImage> imageList = List<AssetImage>.of([
    AssetImage("assets/1.jpg"),
    AssetImage("assets/2.jpg"),
    AssetImage("assets/3.jpg"),
    AssetImage("assets/4.jpg"),
    AssetImage("assets/5.jpg"),
    AssetImage("assets/6.jpg"),
    AssetImage("assets/7.jpg"),
    AssetImage("assets/8.jpg"),
    AssetImage("assets/9.jpg"),
    AssetImage("assets/10.jpg"),
    AssetImage("assets/11.jpg"),
    AssetImage("assets/12.jpg"),
    AssetImage("assets/13.jpg"),
    AssetImage("assets/14.jpg"),
    AssetImage("assets/15.jpg"),
    AssetImage("assets/16.jpg"),
    AssetImage("assets/17.jpg"),
    AssetImage("assets/18.jpg"),
    AssetImage("assets/19.jpg"),
    AssetImage("assets/20.jpg"),
    AssetImage("assets/21.jpg"),
    AssetImage("assets/22.jpg"),
    AssetImage("assets/23.jpg"),
    AssetImage("assets/24.jpg"),
    AssetImage("assets/25.jpg"),
    AssetImage("assets/26.jpg"),
    AssetImage("assets/27.jpg"),
    AssetImage("assets/28.jpg"),
    AssetImage("assets/29.jpg"),
    AssetImage("assets/30.jpg"),
    AssetImage("assets/31.jpg"),
    AssetImage("assets/32.jpg"),
    AssetImage("assets/33.jpg"),
    AssetImage("assets/34.jpg"),
    AssetImage("assets/35.jpg"),
    AssetImage("assets/36.jpg"),
  ]);
  bool autoRotate = true;
  int rotationCount = 2;
  int swipeSensitivity = 2;
  bool allowSwipeToRotate = true;
  RotationDirection rotationDirection = RotationDirection.anticlockwise;
  Duration frameChangeDuration = Duration(milliseconds: 50);
  bool imagePrecached = false;
  String? selectedValue;
  List<String> items = [
    'Toyota Prius',
    'Ford F-150',
    'Volvo XC90',
    'Mazda MX-5 Miata',
    'Lexus RX',
    'Porsche 911',
    'Tesla Model S',
    'Jeep Wrangler',
    'Subaru Outback',
    'Kia Soul'
  ];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateImageList(context));
    super.initState();
  }

  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: round_appbar(),
          preferredSize: Size.fromHeight(kToolbarHeight)),
      drawer: Drawer(
          child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orangeAccent,
              Colors.white,
              Colors.greenAccent,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Card(
              elevation: 10,
              shadowColor: hexStringToColor("57C5B6"),
              child: DrawerHeader(
                child: Row(children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(0),
                        child: Image.network(
                          "${FirebaseAuth.instance.currentUser!.photoURL!}",
                          height: 116,
                          width: 116,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${FirebaseAuth.instance.currentUser!.displayName}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            Card(
              elevation: 10,
              shadowColor: hexStringToColor("57C5B6"),
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                subtitle: Text('Explore the world of Citisens'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Card(
              elevation: 10,
              shadowColor: hexStringToColor("57C5B6"),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                subtitle: Text('View your profile'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Card(
              elevation: 10,
              shadowColor: hexStringToColor("57C5B6"),
              child: ListTile(
                leading: Icon(Icons.currency_rupee_outlined),
                title: Text('Fine portal'),
                subtitle: Text('Keep track of your fines'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Card(
              elevation: 10,
              shadowColor: hexStringToColor("57C5B6"),
              child: ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                subtitle: Text('Get help and support'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Card(
              elevation: 10,
              shadowColor: hexStringToColor("57C5B6"),
              child: ListTile(
                leading: Icon(Icons.contact_mail),
                title: Text('Conatct us'),
                subtitle: Text('Get in touch with us'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Card(
              elevation: 10,
              shadowColor: hexStringToColor("57C5B6"),
              child: ListTile(
                subtitle: Text('Log out of your account'),
                onTap: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("logout"),
                          content: Text("are you sure you want to logout ??"),
                          actions: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => number_page()),
                                      (route) => false);
                                },
                                icon: Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ))
                          ],
                        );
                      });
                },
                selectedColor: Colors.cyan,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(Icons.exit_to_app),
                title: Text(
                  "LogOut",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      )),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 25,
                      width: double.infinity,
                      child: Marquee(
                        text: 'This is an infinte scrolling text',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 20.0,
                        velocity: 100.0,
                        pauseAfterRound: Duration(seconds: 1),
                        startPadding: 0,
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
                    Material(
                      color: Colors.deepOrange[50],
                      child: InkWell(
                        onTap: () async {
                          // Navigator.pushNamed(context, studentAccountRoute);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(219, 124, 5, 5),
                            borderRadius: BorderRadius.zero,
                          ),
                          height: 200,
                          width: 500,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Welcome to \nVJTI Maps',
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  fontSize: 25,
                                  // fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/VJTilogoforappbar.jpeg'),
                                radius: 70,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SENIORS' ADVICE
                        Material(
                          color: Colors.deepOrange[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () async {
                              // final userdata = await userDetails();
                              // Navigator.pushNamed(context, seniorAdviceRoute,
                              //     arguments: userdata);
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      'assets/challan.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    '  My E-Challans  ',
                                    style: TextStyle(
                                      // fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 80),
                        // EXTRA CURRICULARS
                        Material(
                          color: Colors.deepOrange[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              // Navigator.pushNamed();
                              // context, extracurricularsRoute);
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      'assets/accident_report.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Report an Accident',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // NOTES & PYQS
                        Material(
                          color: Colors.deepOrange[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              // Navigator.of(context).pushNamed(notesAndPyqRoute);
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      'assets/Pay_E_Challan.png',
                                      fit: BoxFit.fill,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Pay E-Challan',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 80),
                        // ABOUT VJTI
                        Material(
                          color: Colors.deepOrange[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              // Navigator.pushNamed(context, aboutVJTIRoute);
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      'assets/Girevances.png',
                                      fit: BoxFit.fill,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Grievances',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // GALLERY
                        Material(
                          color: Colors.deepOrange[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              // const url = 'https://play.google.com/store/apps/details?id=com.raviowl.vjtimaps';
                              // launch(url);
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Image.asset(
                                      'assets/about_us.png',
                                      fit: BoxFit.fill,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'About Us',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 80),
                        // HOW TO GET VJTI
                        Material(
                          color: Colors.deepOrange[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              // Navigator.pushNamed(context, howToGetVJTIRoute);
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      'assets/howtoget.png',
                                      fit: BoxFit.fill,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'How to get \nVJTI',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Material(
                      color: Colors.deepOrange[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          // Navigator.pushNamed(context, mapOfVJTIRoute);
                        },
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Image.asset(
                                  'assets/VJTITopView.png',
                                  fit: BoxFit.fill,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Map of \nVJTI',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                )),
          ),
          SlidingUpPanel(
            panel: SingleChildScrollView(
              child: Container(
                color: Colors.cyan,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                      items:
                          items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    (imagePrecached == true)
                        ? ImageView360(
                            key: UniqueKey(),
                            imageList: imageList,
                            autoRotate: true,
                            rotationCount: 1,
                            rotationDirection: RotationDirection.anticlockwise,
                            frameChangeDuration: Duration(milliseconds: 170),
                            swipeSensitivity: swipeSensitivity,
                            allowSwipeToRotate: allowSwipeToRotate,
                          )
                        : Text("Pre-Caching images..."),
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.amber,
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.blueGrey,
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.lightBlueAccent,
                    ),
                  ],
                ),
              ),
            ),
            collapsed: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orangeAccent,
                    Colors.white,
                    Colors.greenAccent,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Center(
                child: Text(
                  'Slide Up',
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                ),
              ),
            ),
            minHeight: 40.0,
            maxHeight: 500.0,
            boxShadow: [],
          ),
        ],
      ),
      //     ElevatedButton(
      //       child: Text("signout"),
      //       onPressed: () async {
      //         await FirebaseServices().signOut();
      //         // ignore: use_build_context_synchronously
      //         Navigator.pushNamedAndRemoveUntil(
      //             context, "number_page", (route) => false);
      //       },
      //     ),
      //     Text("${FirebaseAuth.instance.currentUser!.email}"),
      //     Text("${FirebaseAuth.instance.currentUser!.displayName}"),
      //     Image.network(FirebaseAuth.instance.currentUser!.photoURL!),
      //   ],
      // ),
      // body: Center(
      //   child: Column(
      //     children: [
      //       ElevatedButton(
      //         child: Text("signout"),
      //         onPressed: () async {
      //           await FirebaseServices().signOut();
      //           Navigator.pushNamedAndRemoveUntil(
      //               context, "number_page", (route) => false);
      //         },
      //       ),
      //       Text("${FirebaseAuth.instance.currentUser!.email}"),
      //       Text("${FirebaseAuth.instance.currentUser!.displayName}"),
      //       Image.network(FirebaseAuth.instance.currentUser!.photoURL!),
      //     ],
      //   ),
      // ));
    );
  }

  void updateImageList(BuildContext context) async {
    for (int i = 1; i <= 36; i++) {
      imageList.add(AssetImage('assets/$i.jpg'));
      //* To precache images so that when required they are loaded faster.
      await precacheImage(AssetImage('assets/$i.jpg'), context);
    }
    setState(() {
      imagePrecached = true;
    });
  }
}
