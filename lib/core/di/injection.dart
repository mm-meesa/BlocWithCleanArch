import 'package:blocwithcleanarch/core/network/dio_client.dart';
import 'package:blocwithcleanarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:blocwithcleanarch/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blocwithcleanarch/features/auth/domain/repositories/auth_repository.dart';
import 'package:blocwithcleanarch/features/auth/domain/usecases/login_user.dart';
import 'package:blocwithcleanarch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blocwithcleanarch/features/fincluddata/data/datasources/fincluddata_datasource.dart';
import 'package:blocwithcleanarch/features/fincluddata/data/repositories/fincluddata_repository_impl.dart';
import 'package:blocwithcleanarch/features/fincluddata/domain/repositories/fincluddata_repository.dart';
import 'package:blocwithcleanarch/features/fincluddata/domain/usecases/fincluddata_usecase.dart';
import 'package:blocwithcleanarch/features/fincluddata/presentation/bloc/fincluddata_bloc.dart';
import 'package:blocwithcleanarch/features/fintechData/presentation/bloc/presentaiont_bloc.dart';
import 'package:blocwithcleanarch/features/signup/data/repositories/signup_repository_impl.dart';
import 'package:blocwithcleanarch/features/signup/domain/repositories/signup_repositories.dart';
import 'package:blocwithcleanarch/features/signup/domain/usecases/signup_user.dart';
import 'package:blocwithcleanarch/features/signup/persentation/bloc/signup_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import '../../features/movies/data/datasources/movie_remote_datasource.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/get_movies.dart';
import '../../features/movies/presentation/bloc/movie_bloc.dart';
import '../../features/signup/data/datasources/signup_remote_datasources.dart';

final sl = GetIt.instance;

void setupInjection() {

  sl.registerLazySingleton<DioClient>(() => DioClient());


  // 🔥 Firebase
  sl.registerLazySingleton<FirebaseAuth>(
        () {
      if (Firebase.apps.isEmpty) {
        throw Exception("Firebase not initialized");
      }
      return FirebaseAuth.instance;
    },
  );

  // 🔥 AUTH FEATURE
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl()),);

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton(() => LoginUser(sl()));

  sl.registerFactory(() => AuthBloc(sl()));


  // 🔥 Signup FEATURE
  sl.registerLazySingleton<SignupRemoteDataSources>(() => SignupRemoteDataSources(sl()));

  sl.registerLazySingleton<SignUpRepositories>(() => SignupRepositoryImpl(sl()));

  sl.registerLazySingleton(() => SignUpUser(sl()));

  sl.registerFactory(() => SignUpBloc(sl()));




  // 🎬 MOVIES FEATURE
  sl.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSource(),);
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerFactory(() => MovieBloc(sl()));

  // 🎬 User details FEATURE
  sl.registerLazySingleton<FincluddataDatasource>(() => FincluddataDatasource(dioClient: sl()));
  sl.registerLazySingleton<FincluddataRepository>(() => FincluddataRepositoryImpl(sl()));
  sl.registerLazySingleton(() => FincludDataUsecase(sl()));
  // ✅ Use registerLazySingleton OR just let BlocProvider create it directly
  sl.registerLazySingleton(() => FincluddataBloc(sl()));

  sl.registerFactory(() => PresentaiontBloc(sl()));
}
