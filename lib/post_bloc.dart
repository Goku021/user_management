import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/detail_repository.dart';
import 'package:user_management/post_model.dart';

import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final DetailRepository detailRepository;

  PostBloc(this.detailRepository) : super(PostInitial()) {
    on<FetchPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await detailRepository.fetchUserPosts(event.userId);
        emit(PostSuccess(posts));
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });
    on<AddLocalPostEvent>((event, emit) {
      if (state is PostSuccess) {
        final currentPosts = List<Post>.from((state as PostSuccess).posts);
        final updatedPosts = [event.post, ...currentPosts];
        emit(PostSuccess(updatedPosts));
      }
    });
  }
}
