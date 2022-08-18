part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status);

  final AuthStatus status;

  @override
  List<Object> get props => [status];
}

class AuthUserUpdated extends AuthenticationEvent {
  const AuthUserUpdated(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}


class AuthenticationLogoutRequested extends AuthenticationEvent {}
