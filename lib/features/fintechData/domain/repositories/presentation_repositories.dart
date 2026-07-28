import 'package:blocwithcleanarch/features/fintechData/data/models/presentaiont_data.dart';

abstract class PresentationRepositories{

  Future<List<PresentaiontData>> callGetAllPresentations();
}