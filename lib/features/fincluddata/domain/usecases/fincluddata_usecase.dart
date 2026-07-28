import 'package:blocwithcleanarch/features/fincluddata/data/models/personal_data_model.dart';
import 'package:blocwithcleanarch/features/fincluddata/domain/repositories/fincluddata_repository.dart';

class FincludDataUsecase {

  final FincluddataRepository repository;

  FincludDataUsecase(this.repository);


  Future<List<PersonalDataModel>> call(){
    return repository.callGetAllDataRepo();
  }
}