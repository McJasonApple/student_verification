import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TitleManager {
  Container createTitle(String title) {
    return Container(
        padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(10)),
        //EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: AutoSizeText(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(60), fontFamily: 'Vonique'),
          textScaleFactor: 0.8,
        ));
  }
}
