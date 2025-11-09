import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
//import 'package:fpdart/src/either.dart';

//implementations of the interfaces created in domain layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSources remoteDataSources;
  const AuthRepositoryImpl(this.remoteDataSources);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try{
      final user = await remoteDataSources.getCurrentUserData();
      if(user==null){
        return left(Failure('User not logged in!'));
      }

      return right(user);
    }
    on ServerExceptions catch(e){
      return left(Failure(e.message));
    }
  }
                             
  @override                 
  Future<Either<Failure, User>> signinWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getuser(() async => await remoteDataSources.signinWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getuser(() async => await remoteDataSources.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  //created a function for try and catch, since it is repeatedly used in the codes, also making it easier to add any othre exceptions and other validations.
  Future<Either<Failure, User>> _getuser(Future<User> Function()fn) async {
    try{
      final user = await fn();
      return right(user); //right function gives success message, the argument passed inside the right() is received as success
    }
    on sb.AuthException catch(e){
      return left(Failure(e.message));
    }
    on ServerExceptions catch (e){
      return left(Failure(e.message)); //returns a Failure class message
    }
  }
}

