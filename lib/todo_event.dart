import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class FetchTodosEvent extends TodoEvent {
  final int userId;

  const FetchTodosEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
