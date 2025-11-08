// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signin.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignin _userLogin;
  final CurrentUser _currentUser;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignin userSignin,
    required CurrentUser currentuser,
  }) : _userSignUp = userSignUp,
       _userLogin = userSignin,
       _currentUser = currentuser,
       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp); // created individual functions for catching the events
    on<AuthSignin>(_onAuthSignin);
    on<AuthUserIsSignedIn>(_isUserSignedIn);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  void _onAuthSignin(AuthSignin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  //for getting the current user data
  void _isUserSignedIn(AuthUserIsSignedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());

    return res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        print(r.email);
        emit(AuthSuccess(r),);
      }
    );
  }
}
