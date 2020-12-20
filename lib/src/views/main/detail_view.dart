import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:http/http.dart' as http;
import 'package:villageboard/src/helpers/app_config.dart' as ex;
import 'package:villageboard/src/models/article_data.dart';
import 'package:intl/intl.dart';

class DetailView extends StatefulWidget {

  final ArticleData articleData;

  DetailView({this.articleData});

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    var date = new DateTime.fromMillisecondsSinceEpoch(widget.articleData.createdAt * 1000);

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

                                Navigator.of(context).pushNamed('/Write', arguments: widget.articleData).then((value) => {
                                  reload(value)
                                });

                              },
                              child: Text("수정"),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(padding: EdgeInsets.all(10),),
                            Text(
                              widget.articleData.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(DateFormat('yyyy-MM-dd HH:mm').format(date)),
                            Divider(color: Colors.grey,),
                            Text(widget.articleData.discription),
                            SizedBox(height: 40,),
                            Container(
                              padding: EdgeInsets.only(bottom: width * 0.036),
                              child: Center(
                                child: RaisedButton(
                                  child: Text("삭제", style: TextStyle(color: Colors.white),),
                                  color: Colors.red,
                                  onPressed: () async {
                                    var result = await deleteArticle(context, widget.articleData.createdAt);
                                    if (result) {
                                      Future.delayed(Duration(milliseconds: 500))
                                          .then((value) {
                                        SVProgressHUD.dismiss();
                                        try {
                                          Navigator.of(context).pop(true);
                                        } catch (e) {
                                          print('Error: $e');
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
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
      Navigator.of(context).pop(widget.articleData);
    } catch (e) {
      print('Error: $e');
    }
  }
  
  void reload(ArticleData value) {
    widget.articleData.title = value.title;
    widget.articleData.discription = value.discription;
    setState(() {
    });
  }

  Future<bool> deleteArticle(BuildContext context, int createdAt) async {
    bool result = false;

    SVProgressHUD.show();
    try {
      var urlString = "https://us-central1-villageboard-fd5ba.cloudfunctions.net"+"/board/normal/${createdAt}";
      final response = await http.delete(urlString, headers:{'content-type':'application/json'});
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

    return result;
  }
}
