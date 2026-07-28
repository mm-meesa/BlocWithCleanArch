part of 'fincluddata_bloc.dart';

abstract class FincluddataState {}

class FincluddataLoading extends FincluddataState {}

class FincluddataError extends FincluddataState {
  final String error;

  FincluddataError(this.error);
}

class FincluddataLoaded extends FincluddataState {
  final List<PersonalDataModel> allUserDetails;

  FincluddataLoaded(this.allUserDetails);
}
