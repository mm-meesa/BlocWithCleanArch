import 'package:blocwithcleanarch/features/fintechData/data/models/presentaiont_data.dart';

abstract class PresentaiontState{}

class PresentaiontLoading extends PresentaiontState{}

class PresentaiontError extends PresentaiontState{
  String errorMsg;

  PresentaiontError(this.errorMsg);
}

class PresentaiontLoaded extends PresentaiontState{
  final List<PresentaiontData> allPresentaiontData;

  PresentaiontLoaded(this.allPresentaiontData);
}