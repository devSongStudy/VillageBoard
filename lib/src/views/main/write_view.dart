import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:villageboard/src/helpers/app_config.dart' as ex;
import 'package:http/http.dart' as http;

class WriteView extends StatefulWidget {
  @override
  _WriteViewState createState() => _WriteViewState();
}

class _WriteViewState extends State<WriteView> {

  final _titleInputController = TextEditingController();
  final _descriptionInputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _titleInputController.text = "";
    _descriptionInputController.text = "";
  }

  @override
  void dispose() {
    _titleInputController.dispose();
    _descriptionInputController.dispose();

    super.dispose();
  }

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
                  //color: Colors.pinkAccent,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton(
                              onPressed: closeView,
                              child: Text("Back"),
                            ),
                            RaisedButton(
                              onPressed: () {
                                saveArticle(context);
                              },
                              child: Text("등록"),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: TextField(
                            controller: _titleInputController,
                            decoration: InputDecoration(hintText: "제목을 입력하세요."),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: TextField(
                            controller: _descriptionInputController,
                            decoration: InputDecoration(hintText: "내용을 입력하세요."),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: null,
                          ),
                        ),
                      ],
                    ),
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

  Future<bool> saveArticle(BuildContext context) async {

    FocusScope.of(context).unfocus();

    String title = _titleInputController.text;
    print('title: $title');
    if (title.isEmpty) {
      SVProgressHUD.showError(status: "제목을 입력하세요.");
      return false;
    }

    String discription = _descriptionInputController.text;
    print('discription: $discription');
    if (discription.isEmpty) {
      SVProgressHUD.showError(status: "내용을 입력하세요");
      return false;
    }

    bool result = false;

    SVProgressHUD.show();
    try {
      var urlString = "https://us-central1-villageboard-fd5ba.cloudfunctions.net"+"/board/normal";
      var body = json.encode({
        "title": title,
        "discription": discription
      });
      final response = await http.post(urlString, body: body, headers: {'content-type':'application/json'});
      if (response.statusCode == 200) {
        print("response: $response.body");
        Map<String, dynamic> object = jsonDecode(response.body);
        int resCode = object['resCode'];
        if (resCode == 0) {
          result = true;
        } else {
          throw Exception('$resCode: ${object['resMessage']}');
        }
        SVProgressHUD.dismiss();
      } else {
        throw Exception('failed to load data: ${response.statusCode}');
      }
    } catch (err) {
      print("Error: $err");
      SVProgressHUD.showError(status: err.toString());
      SVProgressHUD.dismiss(delay: Duration(milliseconds: 2000));
    }

    if (result) {

      SVProgressHUD.showSuccess(status: "Success!");

      setState(() {
        _titleInputController.text = "";
        _descriptionInputController.text = "";
      });

      Future.delayed(Duration(milliseconds: 2000)).then((value) {
        SVProgressHUD.dismiss();
        closeView();
      });
    }

    return result;
  }

}
