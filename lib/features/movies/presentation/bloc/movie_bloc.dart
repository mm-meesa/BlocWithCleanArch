
import 'package:blocwithcleanarch/features/movies/presentation/bloc/movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies.dart';

class MovieBloc extends Cubit<MovieState> {
  final GetMovies getMovies;

  MovieBloc(this.getMovies) : super(MovieLoading());

  void fetchMovies() async {
    final movies = await getMovies();
    emit(MovieLoaded(movies));
  }
}
