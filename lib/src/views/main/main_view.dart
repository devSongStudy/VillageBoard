import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:http/http.dart' as http;
import 'package:villageboard/src/helpers/app_config.dart' as ex;
import 'package:villageboard/src/models/article_data.dart';
import 'package:intl/intl.dart';


class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  @override
  void initState() {
    super.initState();

    //loadArticles();
  }

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
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 8),
                  //color: Colors.pinkAccent,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: ex.App(context).appHeight(10),
                        child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                onPressed: showSignInView,
                                child: Text("Log Out"),
                              ),
                              RaisedButton(
                                onPressed: showWriteView,
                                child: Text("Write View"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: loadArticles(),
                          builder: (BuildContext context, AsyncSnapshot <List<ArticleData>> snapshot){
                            if (snapshot.hasError) {
                              return Center(child: Text("Error - ${snapshot.error.toString()}"),);
                            }

                            if (snapshot.hasData == false) {
                              return Center(child: CircularProgressIndicator(),);
                            }

                            return ListView.separated(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                final ArticleData item = snapshot.data[index];
                                var date = new DateTime.fromMillisecondsSinceEpoch(item.createdAt * 1000);
                                return ListTile(
                                      title: Text(item.title),
                                      subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(date)),
                                    );
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            );
                          },
                        ),
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

  void showSignInView() {
    try {
      Navigator.of(context).pushReplacementNamed('/SignIn');
    } catch (e) {
      print('Error: $e');
    }
  }

  void showDetailView() {
    try {
      Navigator.of(context).pushNamed('/Detail');
    } catch (e) {
      print('Error: $e');
    }
  }

  void showWriteView() {
    try {
      Navigator.of(context).pushNamed('/Write');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<ArticleData>> loadArticles() async {
    List<ArticleData> list = [];
    //SVProgressHUD.show();
    try {
      var urlString = "https://us-central1-villageboard-fd5ba.cloudfunctions.net"+"/board/normal";
      final response = await http.get(urlString);
      if (response.statusCode == 200) {
        //print("response: $response.body");
        Map<String, dynamic> object = jsonDecode(response.body);
        int resCode = object['resCode'];
        if (resCode == 0) {
          List articles = object['resData']['articles'];
          if (articles.isNotEmpty) {
            list = articles.map((data) => ArticleData.fromMap(data)).toList();
          }
        } else {
          throw Exception('$resCode: ${object['resMessage']}');
        }
        //SVProgressHUD.dismiss();
      } else {
        throw Exception('failed to load data: ${response.statusCode}');
      }
    } catch (err) {
      print("Error: $err");
      //SVProgressHUD.showError(status: err.toString());
      //SVProgressHUD.dismiss(delay: Duration(milliseconds: 2000));
    }
    return list;
  }
}
