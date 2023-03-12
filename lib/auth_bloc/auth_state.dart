part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class GoogleSignInSuccess extends AuthState {}
class GoogleSignInErrorState extends AuthState {}

class GoogleSignOutSuccess extends AuthState {}