import 'package:flutter/material.dart';
import 'package:movies_app/src/models/movie.dart';
import 'package:movies_app/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final movieProvider = MoviesProvider();
  // final movies = [
  //   'Spiderman',
  //   'Aquaman',
  //   'Batman',
  //   'Superman',
  //   'Flash',
  //   'Justice League',
  // ];

  // final recentMovies = [
  //   'Batman',
  //   'Flash',
  // ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions of our appBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];

    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // Make the results we want to show
    return Container();
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Shows Suggestions when the person types on the searchbar
    if (query.isEmpty) {
      Container();
    }
    return FutureBuilder(
      future: movieProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;
          return ListView(
              children: movies.map((movie) {
            return ListTile(
              title: Text(movie.title),
              subtitle: Text(movie.originalTitle),
              leading: FadeInImage(
                width: 50.0,
                fit: BoxFit.contain,
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(
                  movie.getPosterImg(),
                ),
              ),
              onTap: () {
                close(context, null);
                movie.uniqueId = '';
                Navigator.pushNamed(context, 'detail', arguments: movie);
              },
            );
          }).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  //  @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Shows Suggestions when the person types on the searchbar
  //   final suggestedList = (query.isEmpty)
  //       ? recentMovies
  //       : movies
  //           .where((element) => element.toLowerCase().startsWith(query))
  //           .toList();

  //   return ListView.builder(
  //     itemCount: suggestedList.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(suggestedList[index]),
  //       );
  //     },
  //   );
  // }
}
