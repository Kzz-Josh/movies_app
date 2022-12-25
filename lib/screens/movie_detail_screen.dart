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
    final _movield = ModalRoute.of(context)!.settings.arguments.toString();

    return FutureBuilder(
      future: _fetchDetails(_movield),
      builder: (context, data) {
        while (_id == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(_title),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 10,
                        top: 10,
                      ),
                      width: 200,
                      child: Image.network(
                        _imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white,
                            child: LayoutBuilder(
                              builder: (context, constraint) {
                                return Icon(
                                  Icons.error_outline_sharp,
                                  color: Colors.red,
                                  size: constraint.biggest.width,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        CircleAvatar(
                          backgroundColor: Color(0xffffc400),
                          child: Text(
                            double.parse(_rating.toString()).toStringAsFixed(1),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Genres; ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 20),
                        for (var i in _genres)
                          Column(
                            children: [
                              Text(i.toString()),
                              SizedBox(height: 10),
                            ],
                          ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
