import 'package:flutter/material.dart';

import 'package:movies_app/src/models/movie.dart';
import 'package:movies_app/src/providers/peliculas_provider.dart';
import 'package:movies_app/src/models/actors_model.dart';

class MovieDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: Colors.indigo[300],
        body: CustomScrollView(
          slivers: [
            _crearAppBar(movie),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 10.0,
                ),
                _posterTitle(context, movie),
                _movieDescription(context, movie),
                _createCast(movie),
              ]),
            )
          ],
        ));
  }

  Widget _crearAppBar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(movie.title,
            style: TextStyle(color: Colors.white, fontSize: 20.0)),
        background: FadeInImage(
          image: NetworkImage(movie.getMovieBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 200),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _posterTitle(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(
                  movie.getPosterImg(),
                ),
                height: 200.0,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                movie.originalTitle,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Icon(Icons.star_border),
                  Text(
                    movie.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _movieDescription(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }

  Widget _createCast(Movie movie) {
    final movieProvider = MoviesProvider();

    return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _makeActorsPageView(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _makeActorsPageView(List<Actor> actors) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: actors.length,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemBuilder: (context, index) {
          return _actorCard(actors[index]);
        },
      ),
    );
  }

  Widget _actorCard(Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              height: 150.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(
                actor.getActorPhoto(),
              ),
            ),
          ),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
          )
        ],
      ),
    );
  }
}
