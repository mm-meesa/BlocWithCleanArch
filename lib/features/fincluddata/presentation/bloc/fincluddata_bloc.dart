import 'package:blocwithcleanarch/features/fincluddata/data/models/personal_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/fincluddata_usecase.dart';

part 'fincluddata_state.dart';

class FincluddataBloc extends Cubit<FincluddataState> {

  final FincludDataUsecase getAllDetails;

  FincluddataBloc(this.getAllDetails) : super(FincluddataLoading());

  void fetchAllUserDetails() async {
    try {
      final userDetails = await getAllDetails();
      emit(FincluddataLoaded(userDetails));
    } catch (e) {
      emit(FincluddataError(e.toString())); // add FincluddataError state
    }
  }
}
