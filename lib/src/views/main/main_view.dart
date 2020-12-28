import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:villageboard/src/helpers/app_config.dart' as ex;
import 'package:villageboard/src/models/article_data.dart';
import 'package:intl/intl.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_auth.currentUser.photoURL),
                        ),
                      ),
                      Text(
                        _auth.currentUser.email,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Log Out'),
                  onTap: () {
                    signOut(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: ex.Colors().randomColor(),
                      child: Text('${this.widget}',
                        style: TextStyle(fontSize: 28.0),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                    ),
                  ],
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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

  Future<void> signOut(BuildContext context) async {
    try {
      SVProgressHUD.show();
      await _auth.signOut();
      await _googleSignIn.signOut();
      SVProgressHUD.dismiss();
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
