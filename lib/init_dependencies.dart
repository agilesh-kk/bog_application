import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

//database initialization
Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    //initializes supabase connection
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client); //registers the supabase instance
}

void _initAuth() {

  //registering all the implementations for the signup usecase.
  serviceLocator.registerFactory<AuthRemoteDataSources>(
    () => AuthRemoteDataSourcesImpl(
      supabaseClient: serviceLocator<SupabaseClient>(),
    ),
  );

  serviceLocator.registerFactory <AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(), 
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(), 
    ),
  );

  serviceLocator.registerLazySingleton(
    ()=>AuthBloc(
      userSignUp: serviceLocator(),
    ),
  );
}
