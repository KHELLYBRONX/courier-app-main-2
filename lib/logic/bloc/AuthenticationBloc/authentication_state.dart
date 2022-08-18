part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.authStatus = const AuthStatus.unknown(),
  });

  final AuthStatus authStatus;

  @override
  String toString() {
    return '${authStatus.status}';
  }


  @override
  List<Object> get props => [authStatus];
}
