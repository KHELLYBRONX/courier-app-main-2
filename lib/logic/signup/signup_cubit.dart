import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import 'package:truckngo/data/repositories/authentication_repository.dart';
import 'package:truckngo/logic/signup/models/models.dart';

import 'models/name.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this._authenticationRepository) : super(const SignupState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.password,
        state.confirmedPassword,
        state.name,
        state.phone
      ]),
    ));
  }

  void phoneNumberChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(
      phone: phone,
      status: Formz.validate([
        phone,
        state.name,
        state.email,
        state.password,
        state.confirmedPassword,
      ]),
    ));
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([
        name,
        state.phone,
        state.email,
        state.password,
        state.confirmedPassword,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      status: Formz.validate([
        state.name,
        state.phone,
        state.email,
        password,
        state.confirmedPassword,
      ]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
      status: Formz.validate([
        state.email,
        state.password,
        confirmedPassword,
        state.name,
        state.phone
      ]),
    ));
  }

  void signupFormSubmitted() async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.signUp(
            email: state.email.value,
            password: state.password.value,
            name: state.name.value,
            number: state.phone.value);
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (err) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure, error: err.toString()));
      }
    }
  }
}
