import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_verification/scan_manager.dart';

import 'title_manager.dart';
import 'workplace_scan.dart';
import 'background.dart';

class Login extends StatefulWidget {
  createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ScanManager qrCodeScanner = new ScanManager();
  String _barcodeScanRes = "Unknown";
  List<String> userInfo = new List<String>();
  bool userIsAvailable = false;
  final dbRef = FirebaseDatabase.instance.reference();
  String userID;
  Map<dynamic, dynamic> _usersMap;
  List<dynamic> _users = new List<dynamic>();
  final myController = TextEditingController();
  bool loginButtonPressed = false;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getUserData();
    autoLogIn();
    super.initState();
  }

  void autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');

    if (userID != null) {
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WorkplaceScan()));
      });
    }
  }

  //get user data from database
  void getUserData() {
    dbRef.child("Users").once().then((DataSnapshot snapshot) {
      _usersMap = snapshot.value;
      _usersMap.forEach((key, value) {
        _users.add(key.toString());
      });
    });
  }

  //check if user is in database
  void userAvailable() {
    if (_users.contains(userInfo.elementAt(2))) {
      userIsAvailable = true;
      saveUser();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WorkplaceScan()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User not exist. Please contact your Prof!'),
      ));
    }
  }

  //decoded base64 code
  void getInformationFromBase64Code() async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decoded;
    if (loginButtonPressed) {
      if (myController.text.isNotEmpty) {
        decoded = stringToBase64.decode(myController.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a Base64-Encoded code!'),
        ));
      }
      loginButtonPressed = false;
    } else {
      decoded = stringToBase64.decode(_barcodeScanRes);
    }
    userInfo = decoded.split('|');
    userInfo[2] = userInfo.elementAt(2).replaceFirst('.', '-');
    if (userInfo.isNotEmpty) {
      userAvailable();
    }
  }

  //set user persitent
  void saveUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setString('userNumber', userInfo.elementAt(0));
      prefs.setString('userName', userInfo.elementAt(1));
      prefs.setString('userID', userInfo.elementAt(2));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WorkplaceScan()));
    });
  }

  void getInformation() async{
    _barcodeScanRes = await qrCodeScanner.scanQR();
    setState(() {
      getInformationFromBase64Code();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(10),
              top: ScreenUtil().setWidth(100),
              right: ScreenUtil().setWidth(10)),
          width: ScreenUtil().setWidth(480),
          height: ScreenUtil().setHeight(800),
          decoration: Background().setLoginBackground(),
          child: Stack(children: <Widget>[
            Container(
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            children: [
                              Container(
                                width: 500.r,
                                height: 160.r,
                                child: TitleManager().createTitle('User Login'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(10),
                                    top: ScreenUtil().setWidth(130),
                                    right: ScreenUtil().setWidth(70),
                                    bottom: ScreenUtil().setWidth(10)),
                                child: TextField(
                                  controller: myController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText:
                                        'Enter your "Base64 encoded" code',
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(10),
                                    right: ScreenUtil().setWidth(150)),
                                child: SizedBox(
                                    height: ScreenUtil().setHeight(50),
                                    width: ScreenUtil().setWidth(300),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color.fromRGBO(68, 82, 213, 1)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                side: BorderSide(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1)))),
                                      ),
                                      onPressed: () {
                                        loginButtonPressed = true;
                                        getInformationFromBase64Code();
                                      },
                                      child: AutoSizeText('Login'),
                                    )),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(140),
                                      bottom: ScreenUtil().setWidth(20)),
                                  child: MaterialButton(
                                    onPressed: () {
                                      getInformation();
                                    },
                                    child: Text(
                                      'Have a QR-Code \n Click here to Scan',
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    )))
          ]),
        ));
  }
}
