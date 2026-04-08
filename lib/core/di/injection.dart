
import 'package:get_it/get_it.dart';
import '../../features/movies/data/datasources/movie_remote_datasource.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/get_movies.dart';
import '../../features/movies/presentation/bloc/movie_bloc.dart';

final sl = GetIt.instance;

void setup() {
  sl.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSource());
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerFactory(() => MovieBloc(sl()));
}
