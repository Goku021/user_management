import 'package:equatable/equatable.dart';
import 'package:user_management/post_model.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class FetchPostsEvent extends PostEvent {
  final int userId;

  const FetchPostsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddLocalPostEvent extends PostEvent {
  final Post post;

  const AddLocalPostEvent(this.post);

  @override
  List<Object?> get props => [post];
}
