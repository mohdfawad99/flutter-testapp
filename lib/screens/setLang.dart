import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:splash_app/main.dart';
import 'package:splash_app/screens/intro.dart';
import 'package:picovoice/picovoice_manager.dart';
import 'package:picovoice/picovoice_error.dart';

class SetLang extends StatefulWidget {
  @override
  _SetLangState createState() => _SetLangState();
}

class _SetLangState extends State<SetLang> {
  bool _visible = true;
  bool displayWidget = false;
  bool changePosition = false;

  String _chosenLang;
  String validText = '';
  bool isMute = false;

  var _picovoiceManager;
  Map<String, String> slots;
  void _initPicovoice() async {
    // String platform = Platform.isAndroid ? "android" : "ios";
    String keywordAsset = "assets/porcupine_android.ppn";
    String keywordPath = await _extractAsset(keywordAsset);
    String contextAsset =
        "assets/eyemateCommands_en_android_2021-06-13-utc_v1_6_0.rhn";
    String contextPath = await _extractAsset(contextAsset);

    try {
      _picovoiceManager = await PicovoiceManager.create(
          keywordPath, _wakeWordCallback, contextPath, _inferenceCallback);
      _picovoiceManager.start();
    } on PvError catch (ex) {
      print(ex);
    }
  }

  void _wakeWordCallback() {
    setState(() {
    });
  }

  void _inferenceCallback(Map<String, dynamic> inference) {
    print(inference);
    if (inference['isUnderstood']) {
      Map<String, String> slots = inference['slots'];
      print(slots);
      if (inference['slots']['state'] != null) {
        setState(() {
          _chosenLang = inference['slots']['state'];
        });
        langSubmit();
      }
    } else {
      print('Try again');
    }
    setState(() {
    });
    print(_chosenLang);
  }

  Future<String> _extractAsset(String resourcePath) async {
    // extraction destination
    String resourceDirectory = (await getApplicationDocumentsDirectory()).path;
    String outputPath = '$resourceDirectory/$resourcePath';
    File outputFile = new File(outputPath);

    ByteData data = await rootBundle.load(resourcePath);
    final buffer = data.buffer;

    await outputFile.create(recursive: true);
    await outputFile.writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return outputPath;
  }

  langSubmit() async {
    if (_chosenLang == null) {
      setState(() {
        validText = 'Note: Please Choose a Language';
      });
    } else {
      await sp.setString('langValue', langCodes[_chosenLang]);
      print('Language is set as ${sp.getString('langValue')}');
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OnBoardingPage()),
      );
    }
  }

  Widget dropDown() {
    return DropdownButton<String>(
        focusColor: Colors.white,
        value: _chosenLang,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: Colors.black,
        items: <String>['English', 'Malayalam', 'Hindi']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: Text(
          "Choose a language",
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        onChanged: (String value) {
          setState(() {
            _chosenLang = value;
          });
          print(_chosenLang);
        });
  }

  Widget _logo() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            height: 200,
            width: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: _visible,
            // maintainAnimation: true,
            child: Text(
              'EyeMate',
              style: TextStyle(fontSize: 30.0, fontStyle: FontStyle.normal),
            ),
          ),
          SizedBox(
            height: 200,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        changePosition = true;
        _visible = false;
      });
    });
    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        displayWidget = true;
      });
    });
    _initPicovoice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 25,
              right: 8,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 8),
                child: IconButton(
                  onPressed: () {
                    if (!isMute) {
                      setState(() {
                        isMute = true;
                      });
                    } else {
                      setState(() {
                        isMute = false;
                      });
                    }
                  },
                  icon: Icon(
                    (!isMute) ? Icons.volume_up : Icons.volume_off,
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              top: changePosition ? 150.0 : 300.0,
              duration: Duration(milliseconds: 2500),
              curve: Curves.fastOutSlowIn,
              child: _logo(),
            ),
            Positioned(
              bottom: 200,
              child: Column(
                children: [
                  Visibility(visible: displayWidget, child: dropDown()),
                  Visibility(
                    visible: displayWidget,
                    child: Text(
                      validText,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: displayWidget,
                    child: FlatButton(
                      color: Colors.blue,
                      onPressed: () {
                        langSubmit();
                      },
                      child: Text(
                        'Go',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
