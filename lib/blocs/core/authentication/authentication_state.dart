abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {}

class AuthenticationBeginCheck extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {}

class AuthenticationFail extends AuthenticationState {}
