import 'package:blocwithcleanarch/features/fintechData/data/datasources/presentation_datasources.dart';
import 'package:blocwithcleanarch/features/fintechData/data/models/presentaiont_data.dart';
import 'package:blocwithcleanarch/features/fintechData/domain/repositories/presentation_repositories.dart';

class PresentationRepoImpl extends PresentationRepositories{

  final PresentationDataSources remote;
  PresentationRepoImpl(this.remote);

  @override
  Future<List<PresentaiontData>> callGetAllPresentations() async{
   return await remote.callGetAllDetails();
  }



}