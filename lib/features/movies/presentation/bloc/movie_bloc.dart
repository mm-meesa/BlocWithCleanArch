
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies.dart';

abstract class MovieState {}

class MovieLoading extends MovieState {}
class MovieLoaded extends MovieState {
  final List<Movie> movies;
  MovieLoaded(this.movies);
}

class MovieBloc extends Cubit<MovieState> {
  final GetMovies getMovies;

  MovieBloc(this.getMovies) : super(MovieLoading());

  void fetchMovies() async {
    final movies = await getMovies();
    emit(MovieLoaded(movies));
  }
}
