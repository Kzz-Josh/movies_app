import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class MovieDetailScreen extends StatelessWidget {
  static const routeName = 'movie_detail_screen';

  var _id;
  var _title;
  var _decription;
  var _start;
  var _status;
  var _imageUrl;
  var _rating;
  var _genres;
  var _htmlDescription;

  Future _fetchDetails(String id) async {
    final response = await http
        .get(Uri.parse('https://www.episodate.com/api/show-details?q=$id'));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final list = result['tvShow'];
      _htmlDescription = list['description'];
      final document = parse(_htmlDescription);
      _decription = parse(document.body!.text).documentElement!.text;
      _id = list['id'];
      _title = list['name'];
      _start = list['start_date'];
      _status = list['status'];
      _imageUrl = list['image_thumbnail_path'];
      _rating = list['rating'];
      _genres = list['genres'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final _movield = ModalRoute.of(context)!.settings.arguments.toString;

    return Scaffold(
      appBar: AppBar(
        title: Text('detail'),
      ),
      body: Center(
        child: Text('detail screen content'),
      ),
    );
  }
}
