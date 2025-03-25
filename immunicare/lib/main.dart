import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:immunicare/pages/home.dart';
import 'package:immunicare/pages/addChild.dart';
import 'package:immunicare/pages/login_screen.dart';
import 'package:immunicare/pages/signUp_screen.dart';
import 'package:immunicare/pages/localNotif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';
import 'package:immunicare/theme/app_themes.dart';
import 'package:immunicare/theme/bloc_observer.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set up BLoC observer for debugging
  Bloc.observer = AppBlocObserver();

  // Initialize Firebase for any platform
  if (kIsWeb) {
    // Initialize Firebase for web with proper configuration
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAxoq_iqcCZno-EoL_GcwaDk1zP5P9ImtQ",
        authDomain: "immunicare-f7f24.firebaseapp.com",
        projectId: "immunicare-f7f24",
        storageBucket: "immunicare-f7f24.firebasestorage.app",
        messagingSenderId: "1005232117970",
        appId: "1:1005232117970:web:0c9761a11d768ad8a3350b",
      ),
    );
    print("Web platform detected - Firebase initialized for web testing");
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  } else {
    // Initialize Firebase for mobile platforms
    await Firebase.initializeApp();
  }

  runApp(
    BlocProvider(
      create: (context) => ThemeBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Immuni Care',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User? user = snapshot.data;
                  if (user == null) {
                    return LoginScreen();
                  } else {
                    return MyHomePage(uid: user.uid);
                  }
                }
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          routes: {
            '/login_screen': (context) => LoginScreen(),
            '/signUp_screen': (context) => SignUpScreen(),
            '/localNotif': (context) => NotifPage(),
            '/addChild': (context) => AddChild(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/home') {
              final args = settings.arguments as Map<String, dynamic>?;
              final uid =
                  args?['uid'] ?? FirebaseAuth.instance.currentUser?.uid;

              if (uid != null) {
                return MaterialPageRoute(
                  builder: (context) => MyHomePage(uid: uid),
                );
              } else {
                return MaterialPageRoute(builder: (context) => LoginScreen());
              }
            }
            return null;
          },
        );
      },
    );
  }
}