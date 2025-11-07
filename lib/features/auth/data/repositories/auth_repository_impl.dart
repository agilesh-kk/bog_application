import 'package:blog_app/core/errors/exceptions.dart';
import 'package:blog_app/core/errors/failure.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
//import 'package:fpdart/src/either.dart';

//implementations of the interfaces created in domain layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSources remoteDataSources;
  const AuthRepositoryImpl(this.remoteDataSources);
                             
  @override                 
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSources.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

      return right(user); //right function gives success message, the argument passed inside the right() is received as success
    } on ServerExceptions catch (e) {
      return left(Failure(e.message)); //returns a Failure class message
    }
  }
}
