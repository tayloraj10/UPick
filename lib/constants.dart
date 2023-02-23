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

Map streamingServices = {
  'Netflix':
      'https://cdn.vox-cdn.com/thumbor/lfpXTYMyJpDlMevYNh0PfJu3M6Q=/39x0:3111x2048/920x613/filters:focal(39x0:3111x2048):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/49901753/netflixlogo.0.0.png',
  'Disney Plus':
      'https://www.lowyat.net/wp-content/uploads/2018/11/Disney-Logo-700x464.jpg',
  'Tubi TV': 'https://cdn.adrise.tv/image/app_icon_200x200.png',
  'HBO Max':
      'https://hbomax-images.warnermediacdn.com/2020-05/square%20social%20logo%20400%20x%20400_0.png',
  'fuboTV':
      'https://res.cloudinary.com/crunchbase-production/image/upload/c_lpad,f_auto,q_auto:eco/ylh8b9kxr1eoptlsi9bv',
  'Hoopla':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRftrQk6qzDWUSH-_r_OziOAbG2CEMPNuErgwzRsn8LNRRT5LCANECWtFtW7BgRTGJtmJc&usqp=CAU',
  'Amazon Prime Video':
      'https://www.androidcentral.com/sites/androidcentral.com/files/styles/w1600h900crop/public/article_images/2021/02/prime-video-logo.jpg',
  'Hulu':
      'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/8d42f70b-cd9d-4a9a-b482-9eaa07d6d581/de01215-48409941-4c22-4fea-9684-69915ef15dc5.png/v1/fill/w_979,h_816,q_70,strp/hulu_new_logo_concept_by_superratchetlimited_de01215-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9ODUzIiwicGF0aCI6IlwvZlwvOGQ0MmY3MGItY2Q5ZC00YTlhLWI0ODItOWVhYTA3ZDZkNTgxXC9kZTAxMjE1LTQ4NDA5OTQxLTRjMjItNGZlYS05Njg0LTY5OTE1ZWYxNWRjNS5wbmciLCJ3aWR0aCI6Ijw9MTAyNCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.7pcVplv2Pb0tNGJF7QAiHS2IIwpWUqEAGoeGmRIBICc',
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

Map streamingServicesIcons = {
  'Netflix': 'netflix.png',
  'Disney Plus': 'disney_plus.jpg',
  'Tubi TV': 'tubi.png',
  'HBO Max': 'hbo_max.png',
  'fuboTV': 'fubo.png',
  'Hoopla': 'hoopla.png',
  'Amazon Prime Video': 'prime_video.jpg',
  'Hulu': 'hulu.jpg',
  'VUDU Free': 'vudu.jpg',
  'Starz': 'starz.jpg',
  'HBO Now': 'hbo_now.jpg',
  'Peacock Premium': 'peacock.jpg',
  'Crackle': 'crackle.png',
  'Sling TV': 'sling.jpg'
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
