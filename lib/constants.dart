import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sampling/sampling.dart';
import 'dart:math';

Color appBackgroundColor = Colors.grey[200];

const String imdb_api_key = '4500cc76';
const String movie_db_api_key = '4916feb4e9a67da7d30cb816f69cb88b';
const String urlStub = 'http://www.omdbapi.com/?apikey=a80dc353&t=';
const String imdbURL = 'https://www.imdb.com/title/';
const String posterUrl = 'https://image.tmdb.org/t/p/w500';

const String customCategoriesUrl =
    'https://miro.medium.com/max/3840/1*jfR0trcAPT3udktrFkOebA.jpeg';

const String noPosterUrl =
    'https://linnea.com.ar/wp-content/uploads/2018/09/404PosterNotFoundReverse.jpg';

Map streaming_services = {
  'Netflix':
      'https://cdn.vox-cdn.com/thumbor/lfpXTYMyJpDlMevYNh0PfJu3M6Q=/39x0:3111x2048/920x613/filters:focal(39x0:3111x2048):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/49901753/netflixlogo.0.0.png',
  'Disney Plus':
      'hhttps://www.lowyat.net/wp-content/uploads/2018/11/Disney-Logo-700x464.jpg',
  'Tubi TV': 'https://cdn.adrise.tv/image/app_icon_200x200.png',
  'HBO Max':
      'https://hbomax-images.warnermediacdn.com/2020-05/square%20social%20logo%20400%20x%20400_0.png',
  'fuboTV':
      'https://res.cloudinary.com/crunchbase-production/image/upload/c_lpad,f_auto,q_auto:eco/ylh8b9kxr1eoptlsi9bv',
  'Hoopla': 'https://burbanklibrary.org/sites/default/files/images/image.jpeg',
  'Amazon Prime Video':
      'https://reviewed-com-res.cloudinary.com/image/fetch/s--OCGmezmg--/b_white,c_limit,cs_srgb,f_auto,fl_progressive.strip_profile,g_center,q_auto,w_972/https://reviewed-production.s3.amazonaws.com/1590656678455/Amazon_Prime_Video_tips_1.jpg',
  'Hulu':
      'https://assetshuluimcom-a.akamaihd.net/h3o/facebook_share_thumb_default_hulu.jpg',
  'VUDU Free': 'https://www.soda.com/wp-content/uploads/2020/06/Vudu.jpg',
  'Starz': 'https://www.soda.com/wp-content/uploads/2020/03/starz.jpg',
  'HBO Now':
      'https://www.cnet.com/a/img/BgogZ6xLtBeSjkn9KVoba0cyjHk=/940x0/2019/03/20/9b2efba4-95cc-4e34-9233-f42446ff60f3/hbo-now.png',
  'Peacock Premium':
      'https://www.peacocktv.com/dam/commerce/assets/partners/logo-peacock-social-1200x628.jpg',
  'Crackle': 'https://www.crackle.com/images/crackle-logo-512x512.png',
  'Sling TV':
      'https://yt3.ggpht.com/ytc/AAUvwnhwDT9EGrgkCvkeEZ5cQ0ZGJB44UuF0KNuyll1C4g=s900-c-k-c0x00ffffff-no-rj'
};

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

List getRandomMovies(int n, movieData) {
  dynamic sampler = new ReservoirSampler(n, random: new Random.secure());
  sampler.addAll(movieData);
  return sampler.getSample();
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
