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

  final _scrollController = ScrollController();
  ArticlesData _articlesData;

  @override
  void initState() {
    _articlesData = ArticlesData();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        _articlesData.loadMore();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                        child: StreamBuilder(
                          stream: _articlesData.stream,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData == false) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return RefreshIndicator(
                              onRefresh: _articlesData.refresh,
                              child: ListView.separated(
                                physics: AlwaysScrollableScrollPhysics(),
                                controller: _scrollController,
                                itemCount: snapshot.data.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < snapshot.data.length) {
                                    final ArticleData item = snapshot.data[index];
                                    var date = new DateTime.fromMillisecondsSinceEpoch(item.createdAt * 1000);
                                    return ListTile(
                                      title: Text(item.title),
                                      subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(date)),
                                      onTap: () {
                                        showDetailView(item);
                                      },
                                    );
                                  } else if (_articlesData.hasMore) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: snapshot.data.length > 0 ? null :
                                      Center(
                                        child: RaisedButton(
                                          onPressed: () {
                                            refresh();
                                          },
                                          child: Text('Refresh'),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                              ),
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

  void showDetailView(ArticleData item) {
    try {
      Navigator.of(context).pushNamed('/Detail', arguments: item).then((value) => {
        refresh()
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void showWriteView() {
    try {
      Navigator.of(context).pushNamed('/Write').then((value) => {
        if (value) {
          refresh()
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void refresh() {
    _articlesData.refresh();
    _scrollController.jumpTo(0.0);
  }

}
