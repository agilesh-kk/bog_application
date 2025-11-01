import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/core/theme/app_theme.dart';
import 'package:blog_app/features/auth/presentation/login_page.dart';
import 'package:blog_app/features/auth/presentation/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    //initializes supabase connection
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(MainApp());
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
          
          
        ]
      )
    ]
  );
  
}
