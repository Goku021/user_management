import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsersEvent extends UserEvent {
  final int limit;
  final int skip;

  const FetchUsersEvent({this.limit = 10, this.skip = 0});
}

class SearchUsersEvent extends UserEvent {
  final String query;

  const SearchUsersEvent(this.query);
}

class LoadMoreUsersEvent extends UserEvent {}
