// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/components/loading.dart';
import 'package:upick_test/components/movie_category_banner.dart';
import 'package:upick_test/models/app_data.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPickAppBar(
        showBack: false,
        showJoinSession: true,
        showExtraPage: false,
      ),
      body: Center(
        child: Provider.of<AppData>(context, listen: true).getLoading
            ? Loading()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                          MovieCategoryBanner(
                            title: 'Major Streaming Services',
                            imageName: 'streaming_services.png',
                            type: 'streaming',
                          ),
                          MovieCategoryBanner(
                            title: 'Pick Your Own',
                            imageName: 'custom_categories.jpeg',
                            type: 'filter',
                          ),
                          MovieCategoryBanner(
                            title: 'Most Popular',
                            imageName: 'most_popular.jpg',
                            type: 'popular',
                            widgetContext: context,
                          ),
                          MovieCategoryBanner(
                            title: 'Top Rated',
                            imageName: 'top_rated.jpg',
                            type: 'top rated',
                            widgetContext: context,
                          )
                          // for (var banner
                          //     in Provider.of<appData>(context).homeBanners)
                          //   MovieCategoryBanner(
                          //     title: banner['Title'],
                          //     imageUrl: banner['ImageUrl'],
                          //     data: banner['Data'],
                          //   ),
                          // MovieCategoryBanner(
                          //   title: 'Custom Categories',
                          //   imageUrl: customCategoriesUrl,
                          // ),
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
