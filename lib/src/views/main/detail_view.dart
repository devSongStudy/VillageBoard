import 'package:flutter/material.dart';
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
}
