import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

import 'title_manager.dart';
import 'background.dart';
import 'button_manager.dart';

class InstructionCard extends StatefulWidget {
  final String machineImageURL;

  InstructionCard({this.machineImageURL});

  createState() => _InstructionCardState(machineImageURL: machineImageURL);
}

class _InstructionCardState extends State<InstructionCard> {
  final String machineImageURL;

  _InstructionCardState({this.machineImageURL});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: ButtonManager().backArrowCreator(context),
        body: Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(10),
                top: ScreenUtil().setWidth(100),
                right: ScreenUtil().setWidth(10)),
            width: ScreenUtil().setWidth(480),
            height: ScreenUtil().setHeight(800),
            decoration: Background().setBackground(),
            child: Stack(children: <Widget>[
              Container(
                  child: Column(
                children: [
                  Container(
                    width: 500.r,
                    height: 160.r,
                    child: TitleManager()
                        .createTitle('Safety \nInstruction \nCard'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: GestureDetector(
                        child: Image.network(
                          machineImageURL,
                          height: MediaQuery.of(context).size.height - 274,
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return DetailScreen(
                                    machineImageURL: machineImageURL);
                              },
                            ),
                          );
                        }),
                  )
                ],
              ))
            ])));
  }
}

//For zoom function
class DetailScreen extends StatefulWidget {
  final String machineImageURL;

  DetailScreen({this.machineImageURL});

  @override
  createState() => _DetailScreenState(machineImageURL: machineImageURL);
}

class _DetailScreenState extends State<DetailScreen> {
  final String machineImageURL;

  _DetailScreenState({this.machineImageURL});

  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: ButtonManager().backArrowCreator(context),
      body: InteractiveViewer(
        child: RotatedBox(
          quarterTurns: 0,
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
            child: Image.network(
              machineImageURL,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}
