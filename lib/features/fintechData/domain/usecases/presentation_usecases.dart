import 'package:blocwithcleanarch/features/fintechData/data/models/presentaiont_data.dart';
import 'package:blocwithcleanarch/features/fintechData/domain/repositories/presentation_repositories.dart';

class PresentationUseCases{
  final PresentationRepositories repositories;

  PresentationUseCases(this.repositories);

  Future<List<PresentaiontData>> call(){
    return repositories.callGetAllPresentations();
  }
}