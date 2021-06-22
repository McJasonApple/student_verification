import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'safety_instruction_card.dart';
import 'user_information.dart';
import 'certificates.dart';
import 'title_manager.dart';
import 'background.dart';

class AfterMachineScan extends StatefulWidget {
  final String machine;
  final String requiredCertificate;
  final Map<dynamic, dynamic> userCertificateMap;

  AfterMachineScan(
      {Key key,
      @required this.machine,
      @required this.requiredCertificate,
      this.userCertificateMap});

  @override
  createState() => _AfterMachineScanState(
      machine: machine,
      requiredCertificate: requiredCertificate,
      userCertificateMap: userCertificateMap);
}

class _AfterMachineScanState extends State<AfterMachineScan> {
  final String machine;
  final String requiredCertificate;
  final Map<dynamic, dynamic> userCertificateMap;

  _AfterMachineScanState(
      {@required this.machine,
      @required this.requiredCertificate,
      @required this.userCertificateMap});

  final dbRef = FirebaseDatabase.instance.reference();
  String machineImageURL;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await getMachineImageURL();
  }

  Future<void> getMachineImageURL() async {
    machineImageURL =
        await FirebaseStorage.instance.ref(machine + '.png').getDownloadURL();
  }

  Container getTitleWidget(BuildContext context) {
    if (userCertificateMap.containsKey(requiredCertificate)) {
      return TitleManager()
          .createTitle('You are allowed to use the ' + machine);
    } else {
      return TitleManager()
          .createTitle('You are NOT allowed to use the ' + machine);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(),
          actions: <Widget>[
            IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserInformation())),
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.black,
                ))
          ],
        ),
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
                    children: [
                      Container(
                        width: 500.r,
                        height: 160.r,
                        child: //getTitleWidget(context)
                            Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(10),
                              top: ScreenUtil().setWidth(5),
                              right: ScreenUtil().setWidth(10)),
                          child: TextField(
                              readOnly: true,
                              enabled: false,
                              maxLines: 3,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  filled: true,
                                  fillColor: Color.fromRGBO(213, 227, 245, 1),
                                  hintText: userCertificateMap
                                          .containsKey(requiredCertificate)
                                      ? 'You are allowed to use the ' + machine
                                      : 'You are NOT allowed to use the ' +
                                          machine,
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(25)))),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20),
                                top: ScreenUtil().setWidth(125)),
                            child: SizedBox(
                                height: ScreenUtil().setHeight(200),
                                width: ScreenUtil().setWidth(200),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromRGBO(255, 255, 255, 1)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            side: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 1)))),
                                  ),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InstructionCard(
                                              machineImageURL:
                                                  machineImageURL))),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/safety.png',
                                        width: ScreenUtil().setWidth(180),
                                        height: ScreenUtil().setHeight(150),
                                      ),
                                      AutoSizeText(
                                        'Instruction Card',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(20),
                                top: ScreenUtil().setWidth(125),
                                right: ScreenUtil().setWidth(20)),
                            child: SizedBox(
                                height: ScreenUtil().setHeight(200),
                                width: ScreenUtil().setWidth(200),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromRGBO(255, 255, 255, 1)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            side: BorderSide(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 1)))),
                                  ),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Certificates(
                                                userCertificateList:
                                                    userCertificateMap.keys,
                                                requiredCertificate:
                                                    requiredCertificate,
                                              ))),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/certificate.png',
                                        width: ScreenUtil().setWidth(150),
                                        height: ScreenUtil().setHeight(150),
                                      ),
                                      AutoSizeText(
                                        'Certificates',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            right: ScreenUtil().setWidth(20),
                            top: ScreenUtil().setWidth(20)),
                        child: SizedBox(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(500),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(255, 255, 255, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        side: BorderSide(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 1)))),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: AutoSizeText('Logout ' + machine,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                            )),
                      ),
                      //Padding(
                      //  padding:
                      //      EdgeInsets.only(top: ScreenUtil().setWidth(180)),
                      //  child: ButtonManager().elevatedButtonCreator(
                      //      'Instruction Card', context, InstructionCard()),
                      //),
                      //Padding(
                      //  padding:
                      //      EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                      //  child: SizedBox(
                      //      height: ScreenUtil().setHeight(50),
                      //      width: ScreenUtil().setWidth(300),
                      //      child: ElevatedButton(
                      //        style: ButtonStyle(
                      //          foregroundColor:
                      //              MaterialStateProperty.all<Color>(
                      //                  Colors.white),
                      //          backgroundColor:
                      //              MaterialStateProperty.all<Color>(
                      //                  Color.fromRGBO(66, 66, 66, 1)),
                      //          shape: MaterialStateProperty.all<
                      //                  RoundedRectangleBorder>(
                      //              RoundedRectangleBorder(
                      //                  borderRadius:
                      //                      BorderRadius.circular(12.0),
                      //                  side: BorderSide(
                      //                      color: Color.fromRGBO(
                      //                          255, 255, 255, 1)))),
                      //        ),
                      //        onPressed: () {
                      //          Navigator.push(
                      //              context,
                      //              MaterialPageRoute(
                      //                  builder: (context) => Certificates(
                      //                        userCertificateList:
                      //                            userCertificateMap.keys,
                      //                        requiredCertificate:
                      //                            requiredCertificate,
                      //                      )));
                      //        },
                      //        child: AutoSizeText('Certificates'),
                      //      )),
                      //),
                      //Padding(
                      //  padding:
                      //      EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                      //  child: ButtonManager().elevatedButtonCreator(
                      //      'Logout ' + machine, context, Menue()),
                      //),
                    ],
                  ),
                ),
              ],
            )));
  }
}
