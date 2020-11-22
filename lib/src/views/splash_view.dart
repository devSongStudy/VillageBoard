
import 'package:flutter/material.dart';
import 'package:villageboard/src/helpers/app_config.dart' as ex;

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  color: ex.Colors().randomColor(),
                  child: Text('${this.widget}',
                    style: TextStyle(fontSize: 28.0),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.pinkAccent,
                  width: double.infinity,
                  child: Column(
                    children: [
                      RaisedButton(
                        onPressed: showSignInView,
                        child: Text("SignIn View"),
                      ),
                      RaisedButton(
                        onPressed: showMainView,
                        child: Text("Main View"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  void showSignInView() {
    try {
      Navigator.of(context).pushReplacementNamed('/SignIn');
    } catch (e) {
      print('Error: $e');
    }
  }

  void showMainView() {
    try {
      Navigator.of(context).pushReplacementNamed('/Main');
    } catch (e) {
      print('Error: $e');
    }
  }

}
