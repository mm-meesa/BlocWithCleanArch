
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import 'bloc/movie_bloc.dart';
import 'details_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieBloc>()..fetchMovies(),
      child: Scaffold(
        appBar: AppBar(title: Text("Dashboard")),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) return Center(child: CircularProgressIndicator());
            if (state is MovieLoaded) {
              return ListView.builder(
                itemCount: state.movies.length,
                itemBuilder: (_, i) {
                  final movie = state.movies[i];
                  return ListTile(
                    title: Text(movie.title),
                    onTap: () {
                      Navigator.push(_, MaterialPageRoute(
                        builder: (_) => DetailsPage(movie: movie),
                      ));
                    },
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
