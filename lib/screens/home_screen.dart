import 'package:flutter/material.dart';
import 'package:upick_test/components/movie_category_banner.dart';
import 'package:upick_test/sample_data.dart';

class HomeScreen extends StatelessWidget {
  List<Map<dynamic, dynamic>> homeBannerData_feed;

  HomeScreen({this.homeBannerData_feed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ready to find a movie to watch?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'NunitoSans',
                  fontWeight: FontWeight.w700),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MovieCategoryBanner(
                    title: 'Popular Movies',
                    imageUrl:
                        'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/popular-movies-year-born-1523052006.jpg?crop=1.00xw:1.00xh;0,0&resize=480:*',
                  ),
                  for (var banner in homeBannerData)
                    MovieCategoryBanner(
                        title: banner['Title'], imageUrl: banner['ImageUrl']),
                  MovieCategoryBanner(
                    title: 'Custom Categories',
                    imageUrl:
                        'https://miro.medium.com/max/3840/1*jfR0trcAPT3udktrFkOebA.jpeg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
