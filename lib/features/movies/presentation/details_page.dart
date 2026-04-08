
import 'package:flutter/material.dart';


class DetailsPage extends StatelessWidget {
  final Movie movie;

  DetailsPage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: Center(child: Text(movie.title)),
    );
  }
}
