import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoggedIn;
  final String username;
  final String password;
  final String errorMessage;

  const LoginState({
    required this.isLoggedIn,
    required this.username,
    required this.password,
    this.errorMessage = '',
  });

  LoginState copyWith({
    bool? isLoggedIn,
    String? username,
    String? password,
    String? errorMessage,
  }) {
    return LoginState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoggedIn, username, password, errorMessage];
}