import 'package:blog_app/core/theme/app_theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/signin_page.dart';
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies(); //this function is used for initializing the database instance from the dependency file
  runApp(
    MultiBlocProvider(
      providers: [
        //signup bloc
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(), //loads the abuthbloc contents from the dependency file
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
        name: SigninPage.pageName,
        path: SigninPage.pageName,
        builder: (context, state) => SigninPage(),
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
