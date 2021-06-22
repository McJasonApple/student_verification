import 'package:flutter/material.dart';

class Background {
  BoxDecoration setLoginBackground() {
    return BoxDecoration(
        image: DecorationImage(
      image: AssetImage('assets/images/design_login.png'),
      fit: BoxFit.fill,
    ));
  }

  BoxDecoration setBackground() {
    return BoxDecoration(
        image: DecorationImage(
      image: AssetImage('assets/images/design_all_pages.png'),
      fit: BoxFit.fill,
    ));
  }
}
