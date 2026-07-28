 import 'package:blocwithcleanarch/core/network/dio_client.dart';
import 'package:blocwithcleanarch/features/fintechData/data/models/presentaiont_data.dart';
import 'package:dio/dio.dart';

class PresentationDataSources{


  final DioClient? _dioClient;

  PresentationDataSources({DioClient? dioClient}) : _dioClient = dioClient;


  Future<List<PresentaiontData>> callGetAllDetails() async{

    assert(_dioClient != null, 'DioClient must be provided for registerCustomer');

    try {
      final response = await _dioClient?.dio.get("https://jsonplaceholder.typicode.com/posts");

      if (response?.statusCode == 200) {
        final data = response?.data; // ✅ This is the actual List
        return (data as List).map((e) => PresentaiontData.fromJson(e as Map<String, dynamic>)).toList();
      }

      return [];

    } on DioException catch (e) {
      return  [];
    }
  }
}