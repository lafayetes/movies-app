import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_app/src/models/movie.dart';

class CardSwiper extends StatelessWidget {
  List<Movie> movies;
  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Swiper(
        itemWidth: _screenSize.width * 0.5,
        itemHeight: _screenSize.height * 0.5,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {
          movies[index].uniqueId = '${movies[index].id}-cardSwipe';
          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'detail',
                        arguments: movies[index]);
                  },
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(
                      movies[index].getPosterImg(),
                    ),
                  ),
                )),
          );
        },
        itemCount: movies.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
