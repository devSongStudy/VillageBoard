
import 'package:flutter/foundation.dart';

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