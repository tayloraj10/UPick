import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Color appBackgroundColor = Colors.grey[200];

const String imdb_api_key = '4500cc76';
const String movie_db_api_key = '4916feb4e9a67da7d30cb816f69cb88b';
const String urlStub = 'http://www.omdbapi.com/?apikey=a80dc353&t=';
const String imdbURL = 'https://www.imdb.com/title/';
const String posterUrl = 'https://image.tmdb.org/t/p/w500';

const String noPosterUrl =
    'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFoundReverse.jpg';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

List ratingOptions = ['G', 'PG', 'PG-13', 'NC-17', 'R'];

Map genres = {
  'genres': [
    {'id': 28, 'name': 'Action'},
    {'id': 12, 'name': 'Adventure'},
    {'id': 16, 'name': 'Animation'},
    {'id': 35, 'name': 'Comedy'},
    {'id': 80, 'name': 'Crime'},
    {'id': 99, 'name': 'Documentary'},
    {'id': 18, 'name': 'Drama'},
    {'id': 10751, 'name': 'Family'},
    {'id': 14, 'name': 'Fantasy'},
    {'id': 36, 'name': 'History'},
    {'id': 27, 'name': 'Horror'},
    {'id': 10402, 'name': 'Music'},
    {'id': 9648, 'name': 'Mystery'},
    {'id': 10749, 'name': 'Romance'},
    {'id': 878, 'name': 'Science Fiction'},
    {'id': 10770, 'name': 'TV Movie'},
    {'id': 53, 'name': 'Thriller'},
    {'id': 10752, 'name': 'War'},
    {'id': 37, 'name': 'Western'}
  ]
};
