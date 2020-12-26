import 'package:flutter/material.dart';
import 'package:upick_test/screens/custom_categories_picker.dart';
import 'package:upick_test/screens/session_chooser_page.dart';

class MovieCategoryBanner extends StatelessWidget {
  String title;
  String imageUrl;
  List<Map<dynamic, dynamic>> data;

  MovieCategoryBanner(
      {@required this.title, @required this.imageUrl, @required this.data});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GestureDetector(
          onTap: () {
            if (title == 'Custom Categories')
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomCategoriesPicker(),
                ),
              );
            else
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionChooserPage(
                    movieData: data,
                  ),
                ),
              );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
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
