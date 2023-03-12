part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class GoogleSignInEvent extends AuthEvent {}

class GoogleSignOutEvent extends AuthEvent {}
