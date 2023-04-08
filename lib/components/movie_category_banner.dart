// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';
import 'package:upick_test/screens/custom_categories_picker.dart';
import 'package:upick_test/screens/major_streaming_providers.dart';
import 'package:upick_test/screens/session_chooser_page.dart';

class MovieCategoryBanner extends StatelessWidget {
  final String title;
  final String imageName;
  final String imageUrl;
  final String tooltip;
  final String type;
  final List<Map<dynamic, dynamic>> data;
  final widgetContext;

  MovieCategoryBanner(
      {this.title,
      this.imageName,
      this.type = 'regular',
      this.imageUrl,
      this.data,
      this.tooltip,
      this.widgetContext});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GestureDetector(
          onTap: () async {
            if (type == 'streaming') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MajorStreamingProviders(),
                ),
              );
            } else if (type == 'filter') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomCategoriesPicker(),
                ),
              );
            } else if (type == 'popular') {
              Provider.of<AppData>(widgetContext, listen: false)
                  .updateLoading(true);
              await Provider.of<AppData>(widgetContext, listen: false)
                  .updateMoviesMain('popular');
              Provider.of<AppData>(widgetContext, listen: false)
                  .updateLoading(false);
              Navigator.push(
                widgetContext,
                MaterialPageRoute(
                  builder: (widgetContext) => SessionChooserPage(),
                ),
              );
            } else if (type == 'top rated') {
              Provider.of<AppData>(widgetContext, listen: false)
                  .updateLoading(true);
              await Provider.of<AppData>(widgetContext, listen: false)
                  .updateMoviesMain('top_rated');
              Provider.of<AppData>(widgetContext, listen: false)
                  .updateLoading(false);
              Navigator.push(
                widgetContext,
                MaterialPageRoute(
                  builder: (widgetContext) => SessionChooserPage(),
                ),
              );
            } else if (['netflix', 'hulu', 'hbo', 'amazon prime']
                .contains(type)) {
              Provider.of<AppData>(widgetContext, listen: false)
                  .updateLoading(true);
              await Provider.of<AppData>(widgetContext, listen: false)
                  .updateMoviesStreaming(type);
              Provider.of<AppData>(widgetContext, listen: false)
                  .updateLoading(false);
              Navigator.push(
                widgetContext,
                MaterialPageRoute(
                  builder: (widgetContext) => SessionChooserPage(),
                ),
              );
            }

            // if (title == 'Custom Categories')
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => CustomCategoriesPicker(),
            //     ),
            //   );
            // else {
            //   Provider.of<appData>(context, listen: false)
            //       .updateMovieData(data);
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => SessionChooserPage(),
            //     ),
            //   );
            // }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image.network(
              //   imageUrl,
              //   fit: BoxFit.fill,
              // ),
              Image.asset(
                "assets/images/$imageName",
                fit: BoxFit.fill,
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.85),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'NunitoSans',
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }
}
