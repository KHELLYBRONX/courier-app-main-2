import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:truckngo/Screens/login/login.dart';
import 'package:truckngo/components/background.dart';
import 'package:truckngo/data/repositories/authentication_repository.dart';
import 'package:truckngo/logic/signup/signup_cubit.dart';
import 'package:truckngo/provider/user_phone_number_provider.dart';
import '../maps/maps.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context1) {
    Size size = MediaQuery.of(context1).size;

    return BlocProvider<SignupCubit>(
      create: (context) =>
          SignupCubit(context.read<AuthenticationRepository>()),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status.isSubmissionInProgress) {
            EasyLoading.show(status: 'Creating Account...');
          } else if (state.status.isSubmissionSuccess) {
            EasyLoading.showSuccess('Account Created');
            Provider.of<PhoneNumberProvider>(context, listen: false).setNumber =
                state.password.value;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return MainPage();
              }),
            );
          } else if (state.status.isSubmissionFailure) {
            EasyLoading.showError('Sign Up Failure\n ${state.error}');
          }
        },
        child: Scaffold(
          body: Background(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const Text(
                      "REGISTER",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 36),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: BlocBuilder<SignupCubit, SignupState>(
                      buildWhen: (previous, current) =>
                          previous.email != current.email,
                      builder: (context, state) {
                        return TextFormField(
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
                              context.read<SignupCubit>().emailChanged(email),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.phone != current.phone,
                    builder: (context, state) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          onChanged: (phone) => context
                              .read<SignupCubit>()
                              .phoneNumberChanged(phone),
                          decoration: InputDecoration(
                              hintText: "Enter your phone number",
                              errorText: state.phone.invalid
                                  ? 'invalid phone number'
                                  : null,
                              labelText: "Mobile Number"),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.name != current.name,
                    builder: (context, state) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          onChanged: (name) =>
                              context.read<SignupCubit>().nameChanged(name),
                          decoration: InputDecoration(
                              hintText: "Enter your name",
                              errorText:
                                  state.name.invalid ? 'invalid name' : null,
                              labelText: "Enter name "),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.password != current.password,
                    builder: (context, state) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter your password",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly

                            errorText: state.password.invalid
                                ? 'invalid password'
                                : null,
                          ),
                          onChanged: (password) => context
                              .read<SignupCubit>()
                              .passwordChanged(password),
                          obscureText: true,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.05),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.confirmedPassword != current.confirmedPassword,
                    builder: (context, state) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Please confirm your password",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly

                            errorText: state.confirmedPassword.invalid
                                ? 'passwords do not match'
                                : null,
                          ),
                          onChanged: (confirmpassword) => context
                              .read<SignupCubit>()
                              .confirmedPasswordChanged(confirmpassword),
                          obscureText: true,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.05),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.status != current.status,
                    builder: (context, state) {
                      return Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: RaisedButton(
                          onPressed: state.status.isValidated
                              ? () => context
                                  .read<SignupCubit>()
                                  .signupFormSubmitted()
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
                              "SIGN UP",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context1,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()))
                      },
                      child: const Text(
                        "Already Have an Account? Sign in",
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
      ),
    );
  }
}
