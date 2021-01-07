import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/constants.dart';
import 'package:upick_test/screens/session_chooser_page.dart';
import 'package:upick_test/utilities/fetch_url.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';

class CustomCategoriesPicker extends StatefulWidget {
  @override
  _CustomCategoriesPickerState createState() => _CustomCategoriesPickerState();
}

class _CustomCategoriesPickerState extends State<CustomCategoriesPicker> {
  String genreValue;
  String rating;
  int genreId;
  int rated;

  bool loading = false;

  FetchURL fetcher = FetchURL();

  String urlStub =
      'https://api.themoviedb.org/3/discover/movie?api_key=$movie_db_api_key&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false';
  //'https://api.themoviedb.org/3/discover/movie?api_key=$movie_db_api_key&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&vote_average.gte=8&with_genres=35&page=1'

  void findGenreId(String genreName) {
    genres['genres'].forEach((e) {
      if (e['name'] == genreName) {
        setState(() {
          genreId = e['id'];
        });
      }
    });
  }

  Future<List> getMovieTitles(String requestUrl) async {
    List movieTitles = [];
    for (var i = 1; i <= 5; i++) {
      var data = await fetcher.getData(requestUrl + '&page=$i');
      var dataResults = data['results'];

      dataResults.forEach((e) {
        movieTitles.add(e['title']);
      });
    }
    return movieTitles;
  }

  Future<List<Map<dynamic, dynamic>>> getMovieData(List movieTitles) async {
    List<Map<dynamic, dynamic>> movieData = [];
    for (var movie in movieTitles) {
      String url =
          'https://www.omdbapi.com/?apikey=a80dc353&type=movie&plot=short&t=' +
              movie;
      var data = await fetcher.getData(url);
      Map newData = {};
      if (data['Response'] != 'False') {
        newData['Poster'] = data['Poster'];
        newData['imdbID'] = data['imdbID'];
        newData['Title'] = data['Title'];
        newData['Plot'] = data['Plot'];
        newData['Cast'] = data['Actors'];
        newData['Genres'] = data['Genre'];
        newData['Runtime'] = data['Runtime'];
        newData['Year'] = data['Year'];
        newData['Rating'] = data['imdbRating'];
        newData['Director'] = data['Director'];
        newData['Rated'] = data['Rated'];

        movieData.add(newData);
      }
    }

    return movieData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPickAppBar(),
      body: Center(
        child: Container(
          child: loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Finding your movies',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                            color: Colors.blue),
                      ),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'NunitoSans',
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Text(
                          'Genre',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        DropdownButton(
                          value: genreValue,
                          onChanged: (newValue) {
                            setState(() {
                              genreValue = newValue;
                            });
                            findGenreId(newValue);
                          },
                          items: genres['genres'].map<DropdownMenuItem<String>>(
                            (Map map) {
                              return DropdownMenuItem<String>(
                                child: Text(map['name']),
                                value: map['name'],
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Rating',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        DropdownButton(
                          value: rating,
                          onChanged: (newValue) {
                            setState(() {
                              rating = newValue;
                            });
                          },
                          items: ratingOptions.map<DropdownMenuItem<String>>(
                            (var r) {
                              return DropdownMenuItem<String>(
                                child: Text(r),
                                value: r,
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Movie Score',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          glow: true,
                          itemSize: 30,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (newRating) {
                            setState(() {
                              rated = newRating.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RaisedButton(
                      color: Colors.red,
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        String requestUrl = urlStub;
                        if (genreId != null)
                          requestUrl += '&with_genres=$genreId';
                        if (rating != null)
                          requestUrl +=
                              '&certification=$rating&certification_country=US';

                        // print(requestUrl);

                        if (rated != null) {
                          if (rated == 1)
                            requestUrl += '&vote_average.gte=2';
                          else if (rated == 2)
                            requestUrl += '&vote_average.gte=4';
                          else if (rated == 3)
                            requestUrl += '&vote_average.gte=6';
                          else if (rated == 4)
                            requestUrl += '&vote_average.gte=8';
                          else if (rated == 5)
                            requestUrl += '&vote_average.gte=10';
                        }

                        List movieTitles = await getMovieTitles(requestUrl);
                        List<Map<dynamic, dynamic>> movieData =
                            await getMovieData(movieTitles);

                        Provider.of<appData>(context, listen: false)
                            .updateMovieData(movieData);

                        setState(() {
                          loading = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SessionChooserPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Find Movies',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
