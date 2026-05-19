
import 'package:blocwithcleanarch/core/di/injection.dart';
import 'package:blocwithcleanarch/features/movies/presentation/bloc/movie_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/movie_bloc.dart';
import 'details_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
              return moviesDashboard(state,context);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget moviesDashboard(MovieLoaded state,context){
    return ListView.builder(
      itemCount: state.movies.length,
      itemBuilder: (_, i) {
        final movie = state.movies[i];
        return ListTile(
          title: Text(movie.title),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => DetailsPage(movie: movie),
            ));
          },
        );
      },
    );
  }
}
