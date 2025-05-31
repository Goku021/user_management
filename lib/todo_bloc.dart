import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/detail_repository.dart';

import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final DetailRepository detailRepository;

  TodoBloc(this.detailRepository) : super(TodoInitial()) {
    on<FetchTodosEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await detailRepository.fetchUserTodos(event.userId);
        emit(TodoSuccess(todos));
      } catch (e) {
        emit(TodoError(e.toString()));
      }
    });
  }
}
