
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  Future<List<MovieModel>> callGetMoviesApi() async {
    final response = await http.get(Uri.parse("https://api.tvmaze.com/shows"));
    final data = jsonDecode(response.body);
    return (data as List).map((e) => MovieModel.fromJson(e)).toList();
  }
}
