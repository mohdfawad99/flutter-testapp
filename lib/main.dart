import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:splash_app/screens/modal_fit.dart';
import 'package:splash_app/screens/splashScreen.dart';
import 'package:porcupine/porcupine_manager.dart';
import 'package:porcupine/porcupine_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sp;
var langCodes;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  langCodes = {'English': 'en-US', 'Malayalam': 'ml-IN', 'Hindi': 'hi-IN'};
  sp = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: splashScreen,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  PorcupineManager _porcupineManager;

  void createPorcupineManager() async {
    try {
      _porcupineManager = await PorcupineManager.fromKeywords(
          ["jarvis", "porcupine"], _wakeWordCallback);
    } on PvError catch (err) {
      // handle porcupine init error
    }
    try {
      await _porcupineManager.start();
    } on PvAudioException catch (ex) {
      // deal with either audio exception
    }
  }

  void _wakeWordCallback(int keywordIndex) {
    if (keywordIndex == 0) {
      print('jarvis');
      _incrementCounter();
      // picovoice detected

    } else if (keywordIndex == 1) {
      // porcupine detected
      print('Hello');
      _incrementCounter();
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // Navigator.of(context).pushReplacement(
    //           MaterialPageRoute(builder: (_) => TestWidget()));
    showMaterialModalBottomSheet(
      bounce: true,
      // expand: true,

      // shape: ,
      context: context,
      builder: (context) => Menu(),
    );
    // showCupertinoModalBottomSheet(
    //   expand: false,
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => ModalFit(),
    // );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createPorcupineManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: CupertinoPageScaffold(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
