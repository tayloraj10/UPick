import 'package:flutter/material.dart';
import 'package:upick_test/components/app_bar.dart';
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
                        child:
                            Image.network(posterUrl + '${movieData['Poster']}'),
                        tag: movieData['Title'],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          "Plot",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 24,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Text(
                            movieData['Plot'] ?? '',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          "Cast",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 24,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Nic Cage, Jon Heder, etc...' ?? '',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
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
    );
  }
}
