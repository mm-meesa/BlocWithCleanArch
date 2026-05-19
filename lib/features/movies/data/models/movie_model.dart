
import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel(super.id, super.title);

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(json['id'], json['name']);
  }
}
