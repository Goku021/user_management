import 'package:flutter/material.dart';
import 'package:user_management/user_detail_screen.dart';
import 'package:user_management/user_model.dart';
import 'package:user_management/detail_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final detailRepository = RepositoryProvider.of<DetailRepository>(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.image),
        ),
        title: Text(user.fullName),
        subtitle: Text(user.email),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserDetailScreen(
                user: user,
                detailRepository: detailRepository,
              ),
            ),
          );
        },
      ),
    );
  }
}
