// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/components/app_bar.dart';
import 'package:upick_test/components/movie_category_banner.dart';
import 'package:upick_test/models/app_data.dart';

import '../components/loading.dart';

class MajorStreamingProviders extends StatelessWidget {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UPickAppBar(
          showBack: false, showJoinSession: true, showExtraPage: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Provider.of<AppData>(context, listen: true).getLoading
              ? Loading()
              : Column(
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
                            title: 'Netflix',
                            imageName: 'netflix.png',
                            type: 'netflix',
                            widgetContext: context,
                          ),
                          MovieCategoryBanner(
                            title: 'Hulu',
                            imageName: 'hulu.jpg',
                            type: 'hulu',
                            widgetContext: context,
                          ),
                          MovieCategoryBanner(
                            title: 'HBO Max',
                            imageName: 'hbo_max.png',
                            type: 'hbo',
                            widgetContext: context,
                          ),
                          MovieCategoryBanner(
                            title: 'Amazon Prime Video',
                            imageName: 'prime_video.jpg',
                            type: 'amazon prime',
                            widgetContext: context,
                          )
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
