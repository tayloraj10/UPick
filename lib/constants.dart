import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Color appBackgroundColor = Colors.grey[200];

const String imdb_api_key = '4500cc76';
const String movie_db_api_key = '4916feb4e9a67da7d30cb816f69cb88b';
const String urlStub = 'http://www.omdbapi.com/?apikey=a80dc353&t=';
const String imdbURL = 'https://www.imdb.com/title/';
const String posterUrl = 'https://image.tmdb.org/t/p/w500';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}
