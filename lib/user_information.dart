import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'title_manager.dart';
import 'background.dart';

class UserInformation extends StatefulWidget {
  createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final dbRef = FirebaseDatabase.instance.reference();
  String userID;
  String username;
  String userNumber;

  @override
  void initState() {
    init();
    super.initState();
  }

  //Get the user data
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID');
      username = prefs.getString('userName');
      userNumber = prefs.getString('userNumber');
    });
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('userID');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    logout();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                        (ModalRoute.withName('/')));
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ))
            ]),
        body: Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(10),
              top: ScreenUtil().setWidth(100),
              right: ScreenUtil().setWidth(10)),
          width: ScreenUtil().setWidth(480),
          height: ScreenUtil().setHeight(800),
          decoration: Background().setBackground(),
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 500.r,
                      height: 160.r,
                      child: TitleManager()
                          .createTitle('Profil'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                        top: ScreenUtil().setWidth(130),
                      ),
                      child: AutoSizeText(
                        'Name:',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(10),
                            top: ScreenUtil().setWidth(5),
                            right: ScreenUtil().setWidth(10)),
                        child: TextField(
                          readOnly: true,
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            filled: true,
                            fillColor: Color.fromRGBO(213, 227, 245, 1),
                            hintText: username,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(10),
                        top: ScreenUtil().setWidth(10),
                      ),
                      child: AutoSizeText(
                        'Number:',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(10),
                            top: ScreenUtil().setWidth(5),
                            right: ScreenUtil().setWidth(10)),
                        child: TextField(
                          readOnly: true,
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            filled: true,
                            fillColor: Color.fromRGBO(213, 227, 245, 1),
                            hintText: userNumber,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(
                          left:ScreenUtil().setWidth(10),
                          top: ScreenUtil().setWidth(10),
                        ),
                      child: AutoSizeText(
                        'User ID:',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(10),
                          top: ScreenUtil().setWidth(5),
                          right: ScreenUtil().setWidth(10)),
                      child: TextField(
                        readOnly: true,
                        enabled: false,
                        maxLines: 2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Colors.black)),
                          filled: true,
                          fillColor: Color.fromRGBO(213, 227, 245, 1),
                          hintText: userID,
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
