import 'package:flutter/material.dart';
import 'package:villageboard/src/helpers/app_config.dart' as ex;

class DetailView extends StatefulWidget {
  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
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

  void closeView() {
    try {
      Navigator.of(context).pop();
    } catch (e) {
      print('Error: $e');
    }
  }
}
