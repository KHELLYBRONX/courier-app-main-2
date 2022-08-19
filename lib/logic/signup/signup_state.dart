part of 'signup_cubit.dart';

@immutable
class SignupState extends Equatable {
  const SignupState(
      {this.status = FormzStatus.pure,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.name = const Name.pure(),
      this.phone = const Phone.pure(),
      this.confirmedPassword = const ConfirmedPassword.pure(),
      this.error});

  final FormzStatus status;
  final Email email;
  final Phone phone;
  final Name name;
  final ConfirmedPassword confirmedPassword;
  final Password password;
  final String? error;

  @override
  List<Object?> get props =>
      [status, email, password, name, phone, confirmedPassword, error];

  SignupState copyWith({
    FormzStatus? status,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    String? error,
    Name? name,
    Phone? phone,
  }) {
    return SignupState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      error: error ?? this.error,
    );
  }
}
