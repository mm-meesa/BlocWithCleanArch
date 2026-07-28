
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remote;

  MovieRepositoryImpl(this.remote);


  @override
  Future<List<Movie>> callGetMoviesRepo() async {
    return await remote.callGetMoviesApi();
  }
}
