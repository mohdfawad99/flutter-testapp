import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:splash_app/main.dart';
import 'package:splash_app/screens/intro.dart';

var _chosenLang = sp.getString('langValue');
String lang = langCodes.keys
    .firstWhere((k) => langCodes[k] == _chosenLang, orElse: () => null);



class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Change Language'),
            leading: SizedBox(
              width: 10,
            ),
            trailing: Text(
              lang,
              // langCodes.keys.firstWhere((k) => langCodes[k] == sp.getString('langValue'), orElse: () => null),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            // onTap: () async {
            //   final result =
            //       await Navigator.of(context).push(TutorialOverlay());
            //   if (result == 'Cancel button pressed') {

            //   } else {
            //     setState(() {
            //       lang = result;
            //     });
            //     print('Language set as $lang , ${langCodes[lang]}');
            //   }

            // },
            onTap: () async {
              showMaterialModalBottomSheet(
                bounce: true,
                context: context,
                builder: (context) => ChangeLang(),
              );
              // setState(() {
              //   lang = result;
              // });
            },
          ),
          ListTile(
            title: Text('Voice Command Usage'),
            leading: SizedBox(
              width: 10,
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Help'),
            leading: SizedBox(
              width: 10,
            ),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => OnBoardingPage()),
            ),
          ),
        ],
      ),
    ));
  }
}

class TutorialOverlay extends ModalRoute<String> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Change Language',
            style: TextStyle(color: Colors.white, fontSize: 40.0),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: RaisedButton(
              // padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
              onPressed: () async {
                await sp.setString('langValue', langCodes['English']);
                Navigator.pop(context, 'English');
              },
              child: Text(
                'English',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: RaisedButton(
              // padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
              onPressed: () async {
                await sp.setString('langValue', langCodes['Malayalam']);
                Navigator.pop(context, 'Malayalam');
              },
              child: Text(
                'Malayalam',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: RaisedButton(
              onPressed: () async {
                await sp.setString('langValue', langCodes['Hindi']);
                Navigator.pop(context, 'Hindi');
              },
              child: Text(
                'Hindi',
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: RaisedButton(
              color: Colors.red,
              onPressed: () {
                print('Cancel button pressed');
                Navigator.pop(context, 'Cancel button pressed');
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget buildTransitions(BuildContext context, Animation<double> animation,
  //     Animation<double> secondaryAnimation, Widget child) {
  //   // You can add your own animations for the overlay content
  //   return FadeTransition(
  //     opacity: animation,
  //     child: ScaleTransition(
  //       scale: animation,
  //       child: child,
  //     ),
  //   );
  // }
}

class ChangeLang extends StatefulWidget {
  @override
  _ChangeLangState createState() => _ChangeLangState();
}

class _ChangeLangState extends State<ChangeLang> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('English'),
            leading: SizedBox(
              width: 10,
            ),
            onTap: () async {
              setState(() {
                lang = 'English';
              });
              await sp.setString('langValue', langCodes[lang]);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Malayalam'),
            leading: SizedBox(
              width: 10,
            ),
            onTap: () async {
              setState(() {
                lang = 'Malayalam';
              });
              await sp.setString('langValue', langCodes[lang]);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Hindi'),
            leading: SizedBox(
              width: 10,
            ),
            onTap: () async {
              setState(() {
                lang = 'Hindi';
              });
              await sp.setString('langValue', langCodes[lang]);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ));
  }
}
