import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_verification/scan_manager.dart';

import 'user_information.dart';
import 'workplace_scan.dart';
import 'after_machine_scan.dart';
import 'background.dart';
import 'title_manager.dart';

class Menue extends StatefulWidget {
  String workplace;

  Menue({@required this.workplace});

  @override
  createState() => _MenueState(workplace: workplace);
}

class _MenueState extends State<Menue> {
  String workplace;

  _MenueState({@required this.workplace});

  ScanManager qrCodeScanner = new ScanManager();
  final dbRef = FirebaseDatabase.instance.reference();
  String _barcodeScanRes = "Unknown";
  Map<dynamic, dynamic> _machineMap;
  String currentWorkplace;
  String machineCertificate;
  Map<dynamic, dynamic> _userCertificateMap;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await getEnteredWorkplace();
    getMachine();
    await getUserCertificates();
  }

  //Get all user certificates
  Future<void> getUserCertificates() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString('userID');
    dbRef
        .child('Users')
        .child(userID)
        .child('certificate')
        .once()
        .then((DataSnapshot snapshot) {
      _userCertificateMap = snapshot.value;
    });
  }


  void getInformation() async{
    _barcodeScanRes = await qrCodeScanner.scanBarcodeNormal();
    setState(() {
      machineAvailable();
    });
  }

  //check if scanned machine is in the room
  void machineAvailable() {
    if (_machineMap.containsKey(_barcodeScanRes)) {
      machineCertificate = _machineMap[_barcodeScanRes];
      setMachinePersistent();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AfterMachineScan(
                    machine: _barcodeScanRes,
                    requiredCertificate: machineCertificate,
                    userCertificateMap: _userCertificateMap,
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Machine not found'),
      ));
    }
  }

  //get workplace
  Future<void> getEnteredWorkplace() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentWorkplace = prefs.getString('workplace');
    });
  }

  //Get machines in scanned workplace from database
  void getMachine() {
    dbRef
        .child('Workplaces')
        .child(currentWorkplace)
        .once()
        .then((DataSnapshot snapshot) {
      _machineMap = snapshot.value;
    });
  }

  //set machine persitent
  void setMachinePersistent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('machine', _barcodeScanRes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Stack(children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(10),
                top: ScreenUtil().setWidth(100),
                right: ScreenUtil().setWidth(10)),
            width: ScreenUtil().setWidth(480),
            height: ScreenUtil().setHeight(800),
            decoration: Background().setBackground(),
            child: Column(
              children: [
                Container(
                  width: 500.r,
                  height: 160.r,
                  child:
                      TitleManager().createTitle('Welcome at \n ' + workplace),
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
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(255, 255, 255, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                          color: Color.fromRGBO(0, 0, 0, 1)))),
                            ),
                            onPressed: () => getInformation(),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/qr_code.png',
                                  width: ScreenUtil().setWidth(180),
                                  height: ScreenUtil().setHeight(150),
                                ),
                                AutoSizeText(
                                  'Scan QR-Code',
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
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(255, 255, 255, 1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                          color: Color.fromRGBO(0, 0, 0, 1)))),
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserInformation())),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/user.png',
                                  width: ScreenUtil().setWidth(150),
                                  height: ScreenUtil().setHeight(150),
                                ),
                                AutoSizeText(
                                  'Student Information',
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
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(255, 255, 255, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                          color: Color.fromRGBO(0, 0, 0, 1)))),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorkplaceScan()));
                        },
                        child: AutoSizeText('Logout ' + workplace,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      )),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: ScreenUtil().setWidth(150)),
                //   child:
                //   ButtonManager().elevatedButtonCreator('QR Code Scan', context, MachineScan()),
                // ),
                // Padding(
                //     padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                //     child: ButtonManager().elevatedButtonCreator(
                //         'Student Info', context, UserInformation())),
                // Padding(
                //     padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                //     child: ButtonManager().elevatedButtonCreator(
                //         workplace + ' Logout', context, WorkplaceScan())),
              ],
            ),
          ),
        ]));
  }
}
