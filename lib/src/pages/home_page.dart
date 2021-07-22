import 'package:flutter/material.dart';
import 'package:movies_app/src/search/search_delegate.dart';

import 'package:movies_app/src/widgets/card_swiper_widget.dart';
import 'package:movies_app/src/widgets/movie_horizontal.dart';
import 'package:movies_app/src/providers/peliculas_provider.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = MoviesProvider();
  @override
  Widget build(BuildContext context) {
    moviesProvider.getPopulars();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text('Peliculas en cine'),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _swiperCards(),
            _swiperPopulars(),
          ],
        ),
      ),
    );
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: moviesProvider.getPlayingNow(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _swiperPopulars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: Text(
            'Popular Movies',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
        StreamBuilder(
          stream: moviesProvider.popularMoviesStream,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return MovieHorizontal(
                movies: snapshot.data,
                nextPage: moviesProvider.getPopulars,
              );
            } else {
              return Container(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
