import 'package:blocwithcleanarch/features/fincluddata/data/models/personal_data_model.dart';

abstract class FincluddataRepository {

  Future<List<PersonalDataModel>> callGetAllDataRepo();
}