import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviez24/app/modules/movies/domain/models/reponse/movie.dart';
import 'package:moviez24/app/shared_widgets/loading/custom_loading_indicator.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function() toggleFav;

  const MovieCard({super.key, required this.movie, required this.toggleFav});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          LayoutBuilder(
            builder: (ctx, constrains) => Container(
              height: constrains.maxWidth * 2222 / 1482,
              child: CachedNetworkImage(
                imageUrl: movie.posterPath,
                placeholder: (c, s) => const CustomLoadingIndicator(),
                errorWidget: (c, s, e) {
                  print(e);
                  print(s);
                  return const Center(
                  child: Text('Image unable to load'),
                );
                },
              ),
            ),
          ),
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
