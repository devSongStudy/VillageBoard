
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:villageboard/src/helpers/app_config.dart' as ex;

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => true);
      },
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
                        onPressed: closeView,
                        child: Text("Back"),
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

  void closeView() {
    try {
      Navigator.of(context).pop();
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