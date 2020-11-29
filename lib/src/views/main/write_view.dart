import 'package:flutter/material.dart';
import 'package:villageboard/src/helpers/app_config.dart' as ex;

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
      // TODO: 제목을 입력하세요
      return false;
    }

    String discription = _descriptionInputController.text;
    print('discription: $discription');
    if (discription.isEmpty) {
      // TODO: 내용을 입력하세요
      return false;
    }

    // TODO: 등록


    // TODO: 등록후 결과 메세지 보여주고 이전 화면으로 이동
    setState(() {
      _titleInputController.text = "";
      _descriptionInputController.text = "";
    });

    return true;
  }

}
