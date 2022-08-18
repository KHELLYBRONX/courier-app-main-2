import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:truckngo/data/repositories/authentication_repository.dart';
import 'package:truckngo/data/repositories/user_repository.dart';
import 'package:truckngo/firebase_options.dart';
import 'package:truckngo/logic/bloc/AuthenticationBloc/authentication_bloc.dart';

import 'Screens/login/login.dart';
import 'Screens/maps/bloc/maps_bloc.dart';
import 'Screens/maps/maps.dart';
import 'Screens/screens.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  bool isLoggedIn = AuthService.instance.isLoggedIn;
  runApp(MyApp(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
    isLoggedIn: isLoggedIn,
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..indicatorColor = const Color(0xFFFFCE00)
    ..backgroundColor = Colors.white
    ..textColor = Colors.black
    ..contentPadding = const EdgeInsets.symmetric(horizontal: 55, vertical: 45)
    ..radius = 10.0
    ..textStyle = const TextStyle(
      color: Colors.black,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    )
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true;
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
    required this.isLoggedIn,
  }) : super(key: key);
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final bool isLoggedIn;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              userRepository: userRepository,
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => MapsBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'TRUCKNGO',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFFCE00),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
            ),
            unselectedWidgetColor: const Color(0x50333333),
            shadowColor: const Color(0xFFe6e6e6).withOpacity(0.5),
            backgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Poppins',
            textTheme: TextTheme(
              headline1: GoogleFonts.poppins(
                color: const Color(0xFF111111),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headline2: GoogleFonts.poppins(
                color: const Color(0xFF111111),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              headline3: GoogleFonts.poppins(
                color: const Color(0xFF111111),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              headline4: GoogleFonts.poppins(
                color: const Color(0xFF111111),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              headline5: GoogleFonts.poppins(
                color: const Color(0xFF111111),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              headline6: GoogleFonts.poppins(
                color: Theme.of(context).unselectedWidgetColor,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              bodyText1: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              bodyText2: GoogleFonts.poppins(
                color: const Color(0xFF111111),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: isLoggedIn ? MainPage() : const LoginScreen(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
