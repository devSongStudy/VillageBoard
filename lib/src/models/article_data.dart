import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:http/http.dart' as http;

class ArticleData {
  String title;
  String discription;
  int createdAt;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  ArticleData({
    @required this.title,
    @required this.discription,
    @required this.createdAt,
  });

  ArticleData copyWith({
    String title,
    String discription,
    int createdAt,
  }) {
    return new ArticleData(
      title: title ?? this.title,
      discription: discription ?? this.discription,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ArticleData{title: $title, discription: $discription, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArticleData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          discription == other.discription &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      title.hashCode ^ discription.hashCode ^ createdAt.hashCode;

  factory ArticleData.fromMap(Map<String, dynamic> map) {
    return new ArticleData(
      title: map['title'] as String,
      discription: map['discription'] as String,
      createdAt: map['createdAt'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'title': this.title,
      'discription': this.discription,
      'createdAt': this.createdAt,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class ArticlesData {
  Stream<List<ArticleData>> stream;
  bool hasMore;

  bool _isLoading;
  List<ArticleData> _data;
  StreamController<List<ArticleData>> _controller;

  ArticlesData() {
    _data = List<ArticleData>();
    _controller = StreamController<List<ArticleData>>.broadcast();
    _isLoading = false;
    stream = _controller.stream.map((List<ArticleData> articlesData) {
      return articlesData;
    });

    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) {
    if (clearCachedData) {
      _data = List<ArticleData>();
      hasMore = true;
    }

    if (_isLoading || hasMore == false) {
      return Future.value();
    }

    _isLoading = true;
    return loadArticles(startAfter: clearCachedData ? 0 : _data.last.createdAt).then((value) {
      _isLoading = false;
      _data.addAll(value);
      hasMore = value.isNotEmpty;
      _controller.add(_data);
    });
  }

}

Future<List<ArticleData>>loadArticles({int startAfter=0}) async {
  List<ArticleData> list = [];
  try {
    var urlString = "https://us-central1-villageboard-fd5ba.cloudfunctions.net"+"/board/normal";
    Map<String, String> queryParams = {
      'startAfter': startAfter.toString(),
      'limit': '5'
    };
    String queryString = Uri(queryParameters: queryParams).query;
    final response = await http.get(urlString + "?" + queryString);
    if (response.statusCode == 200) {
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
    } else {
      throw Exception('failed to load data: ${response.statusCode}');
    }
  } catch (err) {
    print("Error: $err");
    SVProgressHUD.showError(status: err.toString());
    SVProgressHUD.dismiss(delay: Duration(milliseconds: 2000));
  }
  return list;
}