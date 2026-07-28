
import 'package:blocwithcleanarch/core/network/dio_client.dart';
import 'package:blocwithcleanarch/features/fincluddata/data/models/personal_data_model.dart';
import 'package:dio/dio.dart';


class FincluddataDatasource {

  final DioClient? _dioClient;
  // Optional — other http methods still work without it
  FincluddataDatasource({DioClient? dioClient}) : _dioClient = dioClient;

  Future<List<PersonalDataModel>> callGetAllData() async {

    assert(_dioClient != null, 'DioClient must be provided for registerCustomer');

    try {
      final response = await _dioClient?.dio.get("https://jsonplaceholder.typicode.com/posts");

      if (response?.statusCode == 200) {
        final data = response?.data; // ✅ This is the actual List
        return (data as List).map((e) => PersonalDataModel.fromJson(e as Map<String, dynamic>)).toList();
      }

      return [];

    } on DioException catch (_) {
      return  [];
    }
  }
}
