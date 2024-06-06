import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/local_storage.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState(isLoggedIn: false, username: '', password: '')) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginCheck>(_onLoginCheck);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    final user = await LocalStorage.getUser();
    if (user['username'] == event.username && user['password'] == event.password) {
      emit(state.copyWith(isLoggedIn: true, username: event.username, password: event.password));
    } else {
      emit(state.copyWith(errorMessage: 'Invalid username or password'));
    }
  }

  Future<void> _onLoginCheck(LoginCheck event, Emitter<LoginState> emit) async {
    final user = await LocalStorage.getUser();
    if (user['username'] != null && user['password'] != null) {
      emit(state.copyWith(username: user['username']!, password: user['password']!));
    }
  }
}