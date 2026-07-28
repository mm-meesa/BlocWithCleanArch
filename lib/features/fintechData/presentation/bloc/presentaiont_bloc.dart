import 'package:blocwithcleanarch/features/fintechData/domain/usecases/presentation_usecases.dart';
import 'package:blocwithcleanarch/features/fintechData/presentation/bloc/presentaiont_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PresentaiontBloc extends Cubit<PresentaiontState> {

  final PresentationUseCases getAllPresentations;

  PresentaiontBloc(this.getAllPresentations) : super(PresentaiontLoading());


  void fetchAllPresentaiontDetials () async {

    try{
      final userDetails = await getAllPresentations();
      emit(PresentaiontLoaded(userDetails));
    }catch(e){
      emit(PresentaiontError(e.toString()));
    }
  }

}