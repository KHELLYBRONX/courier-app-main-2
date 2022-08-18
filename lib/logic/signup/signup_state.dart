part of 'signup_cubit.dart';

@immutable
class SignupState extends Equatable {
  const SignupState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.error
  });

  final FormzStatus status;
  final Email email;
  final ConfirmedPassword confirmedPassword;
  final Password password;
  final String? error;

  @override
  List<Object?> get props => [
        status,
        email,
        password,
        confirmedPassword,
        error
      ];

  SignupState copyWith({
    FormzStatus? status,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    String? error,
  }) {
    return SignupState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      error: error ?? this.error,
    );
  }
}

