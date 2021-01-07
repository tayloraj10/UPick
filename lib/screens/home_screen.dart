import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/components/movie_category_banner.dart';
import 'package:upick_test/constants.dart';
import 'package:upick_test/models/app_data.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPickAppBar(showBack: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Ready to find a movie to watch?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var banner
                        in Provider.of<appData>(context).homeBanners)
                      MovieCategoryBanner(
                        title: banner['Title'],
                        imageUrl: banner['ImageUrl'],
                        data: banner['Data'],
                      ),
                    MovieCategoryBanner(
                      title: 'Custom Categories',
                      imageUrl: customCategoriesUrl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
