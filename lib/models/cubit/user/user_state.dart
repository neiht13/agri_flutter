// user_state.dart
part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User? user;

  UserLoaded({this.user});
}

class UserDeleted extends UserState {}

class UserError extends UserState {
  final String message;

  UserError({required this.message});
}

class PasswordChanged extends UserState {}
