import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:movies_app/src/models/movie.dart';
import 'package:movies_app/src/models/actors_model.dart';

class MoviesProvider {
  String _apikey = '2e0bf24964aca2a15381c5bedff908cc';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _isLoading = false;

  List<Movie> _popularMovies = [];
  // Aqui se genera el controllador del stream que tiene el tipo de dato que se desea mandara broadcast
  final _popularMoviesStreamController =
      StreamController<List<Movie>>.broadcast();

  // Aqui declaramos la forma de crear un sink para el stream de datos que recibe una lista de peliculas
  Function(List<Movie>) get popularMoviesSink =>
      _popularMoviesStreamController.sink.add;
  // Aqui creamos la forma de hacer el stream de datos como se explico en las diapositivas
  Stream<List<Movie>> get popularMoviesStream =>
      _popularMoviesStreamController.stream;

  void disposeStreams() {
    _popularMoviesStreamController?.close();
  }

  Future<List<Movie>> _processData(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final movies = Movies.fromJsonList(decodedData['results']);
    return movies.items;
  }

  Future<List<Movie>> getPlayingNow() async {
    final url = Uri.https(_url, '/3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _processData(url);
  }

  Future<List<Movie>> getPopulars() async {
    if (_isLoading) return [];
    _isLoading = true;

    _popularesPage++;
    final url = Uri.https(_url, '/3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final answer = await _processData(url);
    // Aqui se agregara a la lista que creamos arriba todas las peliculas que se generen
    _popularMovies.addAll(answer);
    // Aqui es donde se esta colocando los datos que seran enviados por el streambuilder
    popularMoviesSink(_popularMovies);
    _isLoading = false;
    return answer;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '/3/movie/$movieId/credits',
        {'api_key': _apikey, 'language': _language});
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = Cast.fromJsonList(decodedData['cast']);

    return cast.actors;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '/3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _processData(url);
  }
}
