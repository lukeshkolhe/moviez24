import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviez24/app/modules/movies/domain/models/reponse/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function() toggleFav;

  const MovieCard({super.key, required this.movie, required this.toggleFav});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Image.network(movie.posterPath),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title),
                      Text(movie.overview, maxLines: 1),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: toggleFav,
                  icon: Icon(
                    Icons.favorite,
                    color: movie.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      );
}
