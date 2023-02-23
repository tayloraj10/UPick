import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upick_test/models/app_data.dart';
import 'package:upick_test/screens/major_streaming_providers.dart';

class MovieCategoryBanner extends StatelessWidget {
  final String title;
  final String imageName;
  final String imageUrl;
  final String tooltip;
  final String type;
  final List<Map<dynamic, dynamic>> data;

  MovieCategoryBanner(
      {this.title,
      this.imageName,
      this.type = 'regular',
      this.imageUrl,
      this.data,
      this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GestureDetector(
          onTap: () {
            if (type == 'streaming') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MajorStreamingProviders(),
                ),
              );
            } else if (type == 'filter') {
            } else if (type == 'popular') {
              Provider.of<AppData>(context, listen: false)
                  .updateMoviesPopular();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SessionChooserPage(),
              //   ),
              // );
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
