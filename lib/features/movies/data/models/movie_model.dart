
import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel(int id, String title) : super(id, title);

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(json['id'], json['name']);
  }
}
