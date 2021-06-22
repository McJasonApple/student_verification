import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonManager {
  SizedBox elevatedButtonCreator(
      String buttonLabel, BuildContext context, Object obj) {
    return SizedBox(
        height: ScreenUtil().setHeight(50),
        width: ScreenUtil().setWidth(300),
        child: ElevatedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor:
                MaterialStateProperty.all<Color>(Color.fromRGBO(66, 66, 66, 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Color.fromRGBO(255, 255, 255, 1)))),
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => obj));
          },
          child: AutoSizeText(buttonLabel),
        ));
  }

  AppBar backArrowCreator(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  AppBar backArrowCreatorPush(BuildContext context, Object newPage) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => newPage),
            (ModalRoute.withName('/'))),
      ),
    );
  }
}
