import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_verification/scan_manager.dart';

import 'user_information.dart';
import 'menu.dart';
import 'title_manager.dart';
import 'background.dart';

class WorkplaceScan extends StatefulWidget {
  @override
  createState() => _WorkplaceScanState();
}

class _WorkplaceScanState extends State<WorkplaceScan> {
  ScanManager qrCodeScanner = new ScanManager();
  final dbRef = FirebaseDatabase.instance.reference();
  String _barcodeScanRes = "Unknown";
  List<dynamic> _workplaces = new List<dynamic>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  //check if workplace exist in database
  void workplaceAvailable() {
    if (_workplaces.contains(_barcodeScanRes)) {
      setWorkplacePersistent();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Menue(
                    workplace: _barcodeScanRes,
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Room not found'),
      ));
    }
  }

  //Get workplaces from database
  void getData() {
    Map<dynamic, dynamic> _workplaceMap;
    dbRef.child("Workplaces").once().then((DataSnapshot snapshot) {
      _workplaceMap = snapshot.value;
      _workplaceMap.forEach((key, value) {
        _workplaces.add(key.toString());
      });
    });
  }

  //Set the workplace persitent
  void setWorkplacePersistent() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('time begin', "Time: " + DateTime.now().toString());
    prefs.setString('workplace', _barcodeScanRes);
  }


  void getInformation() async{
    _barcodeScanRes = await qrCodeScanner.scanBarcodeNormal();
    setState(() {
      workplaceAvailable();
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
          child: Column(
            children: [
              Container(
                width: 500.r,
                height: 160.r,
                child: TitleManager().createTitle('Scan your workplace'),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(130)),
                child: SizedBox(
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(200),
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
                      onPressed: () => getInformation(),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/barcode.png',
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setHeight(150),
                          ),
                          Text(
                            'Scan Barcode',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          )),
    );
  }
}
