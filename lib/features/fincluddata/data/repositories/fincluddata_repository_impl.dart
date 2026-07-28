import 'package:blocwithcleanarch/features/fincluddata/data/models/personal_data_model.dart';

import '../../domain/repositories/fincluddata_repository.dart';
import '../datasources/fincluddata_datasource.dart';

class FincluddataRepositoryImpl implements FincluddataRepository {
  final FincluddataDatasource remote;

  FincluddataRepositoryImpl(this.remote);

  @override
  Future<List<PersonalDataModel>> callGetAllDataRepo() async {
    return await remote.callGetAllData();
  }
}
