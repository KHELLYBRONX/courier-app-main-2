import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:truckngo/data/repositories/authentication_repository.dart';
import 'package:truckngo/logic/loginCubit/models/email.dart';
import 'package:truckngo/logic/loginCubit/models/password.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());
  final AuthenticationRepository _authenticationRepository;

  void onEmailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([state.password, email]),
    ));
  }

  void onPasswordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.email]),
    ));
  }

  void onSubmitted() async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        await _authenticationRepository.logInWithEmailAndPassword(
          email: state.email.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (err) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            error: err.toString(),
          ),
        );
      }
    }
  }
}
