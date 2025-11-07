import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/features/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//this file connects to the supabase, being a remote data source

abstract interface class AuthRemoteDataSources {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });                       
                    
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

//authentication implementations
class AuthRemoteDataSourcesImpl implements AuthRemoteDataSources {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourcesImpl({
    required this.supabaseClient
  });

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try{
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name' : name //the key 'name' has the value String name
        }
      );
      if(response.user == null){
        throw const ServerExceptions('User is null');
      }
      return UserModel.fromJson(response.user!.toJson());
    }
    catch(e){
      throw ServerExceptions(e.toString());
    }
  }
}

//db pass=a5sqn9gti1@