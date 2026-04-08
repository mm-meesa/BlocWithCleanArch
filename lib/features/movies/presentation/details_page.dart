
import 'package:blocwithcleanarch/features/movies/domain/entities/movie.dart';
import 'package:flutter/material.dart';


class DetailsPage extends StatelessWidget {
  final Movie movie;

  const DetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: Center(child: Text(movie.title)),
    );
  }
}
