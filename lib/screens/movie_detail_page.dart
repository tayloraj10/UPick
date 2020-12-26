import 'package:flutter/material.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/components/movie_detail_section.dart';
import 'package:upick_test/constants.dart';

class MovieDetailPage extends StatelessWidget {
  Map movieData;

  MovieDetailPage({@required this.movieData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPickAppBar(),
      body: Container(
        decoration: BoxDecoration(
          color: appBackgroundColor,
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        child: Text(
                          movieData['Title'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 32,
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.w700,
                              color: Colors.lightBlueAccent,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          launchURL(imdbURL + movieData['imdbID']);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        height: 500,
                        child: Hero(
                          child: Image.network('${movieData['Poster']}' == 'N/A'
                              ? noPosterUrl
                              : '${movieData['Poster']}'),
                          tag: movieData['Title'],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          MovieDetailSection(
                            title: 'Plot',
                            text: (movieData['Plot'] ?? '') == 'N/A'
                                ? 'No plot available'
                                : movieData['Plot'] ?? '',
                          ),
                          MovieDetailSection(
                            title: 'Rating',
                            text: movieData['Rating'] == 'N/A'
                                ? 'No rating available'
                                : movieData['Rating'] + '/10',
                          ),
                          MovieDetailSection(
                            title: 'Genre',
                            text: movieData['Genres'] == 'N/A'
                                ? 'No genre available'
                                : movieData['Genres'],
                          ),
                          MovieDetailSection(
                            title: 'Runtime',
                            text: movieData['Runtime'] == 'N/A'
                                ? 'No runtime available'
                                : movieData['Runtime'],
                          ),
                          MovieDetailSection(
                            title: 'Cast',
                            text: movieData['Cast'] == 'N/A'
                                ? 'No cast available'
                                : movieData['Cast'],
                          ),
                          MovieDetailSection(
                            title: 'Director',
                            text: movieData['Director'] == 'N/A'
                                ? 'No director available'
                                : movieData['Director'],
                          ),
                          MovieDetailSection(
                            title: 'Rated',
                            text: movieData['Rated'] == 'N/A'
                                ? 'No rating available'
                                : movieData['Rated'],
                          ),
                          MovieDetailSection(
                            title: 'Year',
                            text: movieData['Year'] == 'N/A'
                                ? 'No year available'
                                : movieData['Year'],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
