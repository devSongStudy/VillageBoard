
import 'package:flutter/material.dart';
import 'package:villageboard/src/helpers/app_config.dart' as ex;

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
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
                        onPressed: showSignUpView,
                        child: Text("SignUp View"),
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
        ),
      ),
    );
  }

  void showSignUpView() {
    try {
      Navigator.of(context).pushNamed('/SignUp');
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
