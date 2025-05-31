import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/create_post_screen.dart';
import 'package:user_management/detail_repository.dart';
import 'package:user_management/post_bloc.dart';
import 'package:user_management/post_event.dart';
import 'package:user_management/post_state.dart';
import 'package:user_management/todo_bloc.dart';
import 'package:user_management/todo_event.dart';
import 'package:user_management/todo_state.dart';
import 'package:user_management/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;
  final DetailRepository detailRepository;

  const UserDetailScreen({
    super.key,
    required this.user,
    required this.detailRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (_) =>
              PostBloc(detailRepository)..add(FetchPostsEvent(user.id)),
        ),
        BlocProvider<TodoBloc>(
          create: (_) =>
              TodoBloc(detailRepository)..add(FetchTodosEvent(user.id)),
        ),
      ],
      child: Builder(
        // Builder gives a new context under the MultiBlocProvider
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(user.fullName),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<PostBloc>(context),
                          child: const CreatePostScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.image),
                      radius: 30,
                    ),
                    title: Text(user.fullName),
                    subtitle: Text(user.email),
                  ),
                  const SizedBox(height: 10),
                  const Text('Posts',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
                        if (state is PostLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is PostError) return Text(state.message);
                        if (state is PostSuccess) {
                          return ListView.builder(
                            itemCount: state.posts.length,
                            itemBuilder: (_, i) => ListTile(
                              title: Text(state.posts[i].title),
                              subtitle: Text(state.posts[i].body),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Todos',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: BlocBuilder<TodoBloc, TodoState>(
                      builder: (context, state) {
                        if (state is TodoLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is TodoError) return Text(state.message);
                        if (state is TodoSuccess) {
                          return ListView.builder(
                            itemCount: state.todos.length,
                            itemBuilder: (_, i) => ListTile(
                              title: Text(state.todos[i].todo),
                              trailing: Icon(
                                state.todos[i].completed
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: state.todos[i].completed
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
