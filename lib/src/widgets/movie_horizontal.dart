import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;
  MovieHorizontal({@required this.movies, @required this.nextPage});
  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.4,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    // Este listener te permite saber cuando estas por llegar al borde del scroll
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.3,
      //como detalle laqui se modifico a pageview.builder porque este se encarga de renderizar los widgets de acuerdo a que se van creando, de forma que evita utilizar demasiada memoria a diferencia del pageview que renderiza todo
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _movieCardBuilder(context, movies[index]);
        },
        //children: _movieCards(context),
      ),
    );
  }

  // Este metodo nos permite crear una tarjeta que se cree en el pageview.builder
  Widget _movieCardBuilder(BuildContext context, Movie movie) {
    movie.uniqueId = '${movie.id}-horizontalCard';
    final movieCard = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(
                  movie.getPosterImg(),
                ),
                fit: BoxFit.cover,
                width: 400,
                height: 200,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
    return GestureDetector(
      child: movieCard,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }

  List<Widget> _movieCards(BuildContext context) {
    return movies.map((movie) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(
                  movie.getPosterImg(),
                ),
                fit: BoxFit.cover,
                width: 400,
                height: 200,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    }).toList();
  }
}
