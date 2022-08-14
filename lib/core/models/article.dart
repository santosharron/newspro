import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../config/app_images_config.dart';

class ArticleModel {
  int id;
  String title;
  String content;
  String link;
  String featuredImage;
  String heroTag;
  List<int> categories;
  List<int> tags;
  DateTime date;
  bool commentStatus;
  int authorID;
  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.link,
    required this.featuredImage,
    required this.heroTag,
    required this.categories,
    required this.tags,
    required this.date,
    required this.commentStatus,
    required this.authorID,
  });

  ArticleModel copyWith({
    int? id,
    String? title,
    String? content,
    String? link,
    String? featuredImage,
    String? heroTag,
    List<int>? categories,
    List<int>? tags,
    DateTime? date,
    bool? commentStatus,
    int? authorID,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      link: link ?? this.link,
      featuredImage: featuredImage ?? this.featuredImage,
      heroTag: heroTag ?? this.heroTag,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      date: date ?? this.date,
      commentStatus: commentStatus ?? this.commentStatus,
      authorID: authorID ?? this.authorID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'link': link,
      'featuredImage': featuredImage,
      'heroTag': heroTag,
      'categories': categories,
      'tags': tags,
      'date': date.millisecondsSinceEpoch,
      'commentStatus': commentStatus,
      'authorID': authorID,
    };
  }

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title']['rendered'],
      content: map['content']['rendered'] ?? '',
      link: map['link'] ?? '',
      featuredImage: map['featured_image_url'] ?? AppImagesConfig.noImageUrl,
      heroTag: map['slug'] ?? '',
      categories: List<int>.from(map['categories']),
      tags: List<int>.from(map['tags']),
      date: DateTime.parse(map['date_gmt']),
      commentStatus: map['comment_status'].toString() == 'open' ? true : false,
      authorID: map['author']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ArticleModel.fromJson(String source) =>
      ArticleModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ArticleModel(id: $id, title: $title, content: $content, link: $link, featuredImage: $featuredImage, heroTag: $heroTag, categories: $categories, tags: $tags, date: $date, commentStatus: $commentStatus, authorID: $authorID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArticleModel &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.link == link &&
        other.featuredImage == featuredImage &&
        listEquals(other.categories, categories) &&
        listEquals(other.tags, tags) &&
        other.date == date &&
        other.commentStatus == commentStatus &&
        other.authorID == authorID;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        link.hashCode ^
        featuredImage.hashCode ^
        heroTag.hashCode ^
        categories.hashCode ^
        tags.hashCode ^
        date.hashCode ^
        commentStatus.hashCode ^
        authorID.hashCode;
  }
}
