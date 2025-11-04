import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/core/theme/app_theme.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
    //initializes supabase connection
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        //signup bloc
        BlocProvider(
          create: (_) => AuthBloc(
            userSignUp: UserSignUp(
              AuthRepositoryImpl(
                AuthRemoteDataSourcesImpl(
                  supabaseClient: supabase.client
                ),
              ),
            ),
          ),
        ),


      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Blog app',
      routerConfig: _router, //routing setup
      theme: AppTheme.darkThemeMode,
      //home: const LoginPage(),
    );
  }

  final _router = GoRouter(
    routes: [
      GoRoute(
        //the landing page is sign in page
        name: LoginPage.pageName,
        path: LoginPage.pageName,
        builder: (context, state) => LoginPage(),
        routes: [
          GoRoute(
            name: SignupPage.pageName,
            path: SignupPage.pageName,
            builder: (context, state) => SignupPage(),
          ),
        ],
      ),
    ],
  );
}
