import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  int _skip = 0;
  final int _limit = 10;
  bool _hasReachedEnd = false;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
    on<LoadMoreUsersEvent>(_onLoadMoreUsers);
    on<SearchUsersEvent>(_onSearchUsers);
  }

  Future<void> _onFetchUsers(
      FetchUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      _skip = 0;
      final users = await userRepository.fetchUsers(limit: _limit, skip: _skip);
      _hasReachedEnd = users.length < _limit;
      emit(UserSuccess(users: users, hasReachedEnd: _hasReachedEnd));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadMoreUsers(
      LoadMoreUsersEvent event, Emitter<UserState> emit) async {
    if (_hasReachedEnd || state is! UserSuccess) return;

    final currentState = state as UserSuccess;
    _skip += _limit;
    try {
      final moreUsers =
          await userRepository.fetchUsers(limit: _limit, skip: _skip);
      _hasReachedEnd = moreUsers.length < _limit;
      emit(currentState.copyWith(
        users: [...currentState.users, ...moreUsers],
        hasReachedEnd: _hasReachedEnd,
      ));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onSearchUsers(
      SearchUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final results = await userRepository.searchUsers(event.query);
      emit(UserSuccess(users: results, hasReachedEnd: true));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
