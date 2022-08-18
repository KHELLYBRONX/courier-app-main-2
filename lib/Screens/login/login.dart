import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:formz/formz.dart';
import 'package:truckngo/Screens/maps/maps.dart';

import 'package:truckngo/Screens/register/register.dart';
import 'package:truckngo/components/background.dart';
import 'package:truckngo/data/repositories/authentication_repository.dart';
import 'package:truckngo/logic/bloc/AuthenticationBloc/authentication_bloc.dart';
import 'package:truckngo/logic/loginCubit/login_cubit.dart';
import 'package:truckngo/models/wrappers/auth_status.dart';

import 'package:location/location.dart';

import '../maps/location.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  LocationHelper locationData = LocationHelper();

  Future<void> getLocationData() async {
    locationData = LocationHelper();
    await locationData.getCurrentLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      //
    }
  }
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthenticationRepository>()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state.authStatus.status ==
                  AuthenticationStatus.authenticated) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return MainPage();
                  }),
                );
              }
            },
          ),
          BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status.isSubmissionInProgress) {
                EasyLoading.show(status: 'Authorizing...');
              } else if (state.status.isSubmissionFailure) {
                EasyLoading.showError(
                    'Authentication Failure\n ${state.error}');
              } else if (state.status.isSubmissionSuccess) {
                EasyLoading.showSuccess('Account Authenticated');
              }
            },
          ),
        ],
        child: Scaffold(
          body: Background(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.email != current.email,
                  builder: (context, state) {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          errorText:
                              state.email.invalid ? 'invalid email' : null,
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (email) =>
                            context.read<LoginCubit>().onEmailChanged(email),
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.password != current.password,
                    builder: (context, state) {
                      return TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly

                          errorText: state.password.invalid
                              ? 'invalid password'
                              : null,
                        ),
                        onSaved: (newValue) => password = newValue,
                        onChanged: (password) => context
                            .read<LoginCubit>()
                            .onPasswordChanged(password),
                        obscureText: true,
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: const Text(
                    "Forgot your password?",
                    style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      return RaisedButton(
                        onPressed: state.status.isValidated
                            ? () => context.read<LoginCubit>().onSubmitted()
                            : null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              gradient: const LinearGradient(colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ])),
                          padding: const EdgeInsets.all(0),
                          child: const Text(
                            "LOGIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()))
                    },
                    child: const Text(
                      "Don't Have an Account? Sign up",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
