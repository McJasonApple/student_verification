import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'user_information.dart';
import 'title_manager.dart';
import 'background.dart';

class Certificates extends StatelessWidget {
  final Iterable<dynamic> userCertificateList;
  final String requiredCertificate;
  List<String> machines;
  bool certificateAvailable = true;

  Certificates(
      {@required this.userCertificateList, @required this.requiredCertificate});

  Padding printRequiredCertificate(BuildContext context) {
    Color certificateNotAvailableColor = Colors.black;

    if (!userCertificateList.contains(requiredCertificate)) {
      certificateAvailable = false;
      certificateNotAvailableColor = Colors.red;
    }

    return Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setWidth(165)),
        child: Container(
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
            width: 500.r,
            height: 100.r,
            child: Column(
              children: [
                Container(
                  width: 500.r,
                  height: 50.r,
                  child: AutoSizeText(
                    "Required Certificate:",
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: 500.r,
                  height: 50.r,
                  child:
                      //Row(
                      //  children: [
                      AutoSizeText(
                    requiredCertificate,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: certificateNotAvailableColor,
                        fontSize: ScreenUtil().setSp(20)),
                  ),
                ))
              ],
            )));
  }

  Expanded printUserCertificate() {
    return Expanded(
        child: SizedBox(
            child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
          child: Container(
              width: 500.r,
              height: 50.r,
              child: AutoSizeText(
                "Your Certificates:",
                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              )),
        ),
        Expanded(
            child: ListView.separated(
          padding: EdgeInsets.only(top: ScreenUtil().setWidth(5)),
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 15,
            color: Colors.black,
            indent: 40,
            endIndent: 40,
          ),
          itemCount: userCertificateList.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
              title: AutoSizeText(
                '${(index + 1).toString()}. ${userCertificateList.elementAt(index).toString()}',
              ),
            );
          },
        ))
      ],
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        //appBar: ButtonManager().backArrowCreator(context),
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
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserInformation())),
                  icon: Icon(
                    Icons.account_circle_outlined,
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
                    children: [
                      Container(
                        width: 500.r,
                        height: 100.r,
                        child: TitleManager().createTitle('Certificate'),
                      ),
                      printRequiredCertificate(context),
                      Padding(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                        child: Divider(
                          height: 30,
                          color: Colors.black,
                          thickness: 4,
                        ),
                      ),
                      printUserCertificate(),
                    ],
                  ),
                ),
              ],
            )));
  }
}
