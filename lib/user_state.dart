import 'package:equatable/equatable.dart';
import 'package:user_management/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final List<User> users;
  final bool hasReachedEnd;

  const UserSuccess({required this.users, this.hasReachedEnd = false});

  UserSuccess copyWith({List<User>? users, bool? hasReachedEnd}) {
    return UserSuccess(
      users: users ?? this.users,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [users, hasReachedEnd];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
