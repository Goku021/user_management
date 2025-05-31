import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management/post_bloc.dart';
import 'package:user_management/post_event.dart';
import 'package:user_management/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        body: _bodyController.text,
      );

      context.read<PostBloc>().add(AddLocalPostEvent(post));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bodyController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Body'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter body' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Post'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
