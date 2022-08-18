import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:truckngo/data/repositories/authentication_repository.dart';
import 'package:truckngo/data/repositories/user_repository.dart';
import 'package:truckngo/models/models.dart';
import 'package:truckngo/models/wrappers/auth_status.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState()) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
    _userSubscription = _userRepository.apiUser.listen(
      (user) => add(AuthUserUpdated(user)),
    );
    on<AuthenticationStatusChanged>(
        (event, emit) => emit(AuthenticationState(authStatus: (event).status)));
    on<AuthenticationLogoutRequested>(
        (event, emit) => (_authenticationRepository.logOut()));
    on<AuthUserUpdated>((event, emit) {
      AuthStatus authStatus = state.authStatus.copyWith(
        authData: state.authStatus.authData!.rebuild(
          (a) => a..user = (event).user.toBuilder(),
        ),
      );
      emit(AuthenticationState(authStatus: authStatus));
    });
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<AuthStatus> _authenticationStatusSubscription;
  late StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    _userSubscription.cancel();
    return super.close();
  }

  // ignore: unused_element
  // Future<User?> _tryGetUser() async {
  //   try {
  //     final User? user = await _userRepository.getUser();
  //     return user;
  //   } on Exception {
  //     return null;
  //   }
  // }

  // void _addTimer() {
  //   if (state.authStatus.status == AuthenticationStatus.authenticated) {
  //     Timer(Duration(hours: Int(state.authStatus.authData!.expiresIn)), () {
  //       this.add(AuthenticationLogoutRequested());
  //     });
  //   }
  // }
}
