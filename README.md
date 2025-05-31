# User Management Flutter App
-----Images Of this Project---
Home Screen:-
![Screenshot 2025-05-31 212323](https://github.com/user-attachments/assets/507edb4a-1aad-4ff2-913d-32fea0608f29)

Search Screen :-
![Screenshot 2025-05-31 212419](https://github.com/user-attachments/assets/3f0ea719-a339-4aaa-ab83-fb2a4fd9a8c6)

User Details Screen:-
![Screenshot 2025-05-31 212437](https://github.com/user-attachments/assets/cd4ad259-9bfa-4c1f-b202-d9463f901066)

Add Post Screen:-
![Screenshot 2025-05-31 212611](https://github.com/user-attachments/assets/b9cc1a8c-de59-46ce-808b-2bd67abc2e86)

User Details After Adding a Post:-
![Screenshot 2025-05-31 212626](https://github.com/user-attachments/assets/93e25d89-0716-4394-a470-5f7286df602e)







A Flutter application showcasing a user management system with posts and todos, leveraging the *
*BLoC (Business Logic Component) pattern** for robust state management and the repository pattern
for clean data access. This project demonstrates proper dependency injection, asynchronous data
handling, and navigation with Bloc state preservation.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture & Design](#architecture--design)
- [Features](#features)
- [Setup and Installation](#setup-and-installation)
- [Detailed Explanation of the Code](#detailed-explanation-of-the-code)
    - [Main.dart](#maindart)
    - [UserDetailScreen.dart](#userdetailscreendart)
- [Common Issues and Fixes](#common-issues-and-fixes)
    - [BlocProvider Context Error](#blocprovider-context-error)
- [Dependencies](#dependencies)
- [Folder Structure](#folder-structure)
- [Future Improvements](#future-improvements)
- [License](#license)

---

## Project Overview

This Flutter app fetches and displays a list of users from a remote API. Upon selecting a user, you
can view detailed information, including their posts and todos. You can also create new posts
associated with the user.

The app uses the **BLoC pattern** to manage states and separate UI from business logic, making the
app scalable and maintainable. The repository pattern abstracts API calls, simplifying testing and
data management.

---

## Architecture & Design

### 1. **Repository Pattern**

- `ApiService` handles all network requests.
- `UserRepository` and `DetailRepository` fetch users, posts, and todos respectively.
- This abstraction helps isolate data sources from UI logic.

### 2. **BLoC Pattern**

- Separate BLoCs for users (`UserBloc`), posts (`PostBloc`), and todos (`TodoBloc`).
- Each Bloc manages its own events and states.
- `BlocProvider` injects blocs into the widget tree.
- `BlocBuilder` listens and rebuilds UI based on state changes.

### 3. **Dependency Injection**

- `MultiRepositoryProvider` injects repositories at the root of the app.
- `MultiBlocProvider` injects multiple blocs scoped to the screen (like posts and todos for a
  specific user).
- This ensures single responsibility and loose coupling.

### 4. **Navigation**

- Navigates from user list to user detail screen passing the user object and repositories.
- Uses `BlocProvider.value` to reuse existing blocs when navigating to create post screen to keep
  state consistent.

---

## Features

- Fetch and display a list of users.
- View detailed user information (name, email, avatar).
- Display lists of posts and todos for each user.
- Create new posts with form input.
- Loading and error handling states with user-friendly UI feedback.
- Proper bloc context management to avoid common Flutter errors.

---

## Setup and Installation

### Prerequisites

- Flutter SDK (version 3.0+ recommended)
- A device or emulator configured for Flutter development

### Steps

1. **Clone the repo:**

```bash
git clone https://github.com/Goku021/user_management_flutter.git
cd user_management_flutter

Install dependencies:

flutter pub get

    Run the app:

flutter run

Detailed Explanation of the Code
Main.dart

    Sets up MultiRepositoryProvider for injecting UserRepository and DetailRepository app-wide.

    Wraps the app inside MaterialApp.

    Provides UserBloc using BlocProvider scoped to the UserListScreen.

    UserListScreen fetches and displays users.

UserDetailScreen.dart

    Receives a User instance and DetailRepository.

    Uses MultiBlocProvider to create PostBloc and TodoBloc scoped for this screen.

    Adds initial events (FetchPostsEvent and FetchTodosEvent) with the user's id.

    Wraps the Scaffold inside a Builder widget to ensure the correct BuildContext is used to access the blocs.

    Displays user details with a profile picture, name, and email.

    Shows post and todo lists with BlocBuilder reacting to states (loading, error, success).

    The AppBar's add button navigates to CreatePostScreen passing the current PostBloc instance using BlocProvider.value.

Common Issues and Fixes
BlocProvider Context Error

Error:

BlocProvider.of() called with a context that does not contain a PostBloc.

Cause:

The BuildContext used to access a bloc is outside the widget subtree where that bloc is provided.

Fix:

Wrap the widget that needs access to the bloc inside a Builder widget within the MultiBlocProvider. The Builder creates a new BuildContext that is a descendant of the BlocProvider.

MultiBlocProvider(
  providers: [
    BlocProvider<PostBloc>(
      create: (_) => PostBloc(detailRepository)..add(FetchPostsEvent(user.id)),
    ),
    BlocProvider<TodoBloc>(
      create: (_) => TodoBloc(detailRepository)..add(FetchTodosEvent(user.id)),
    ),
  ],
  child: Builder(
    builder: (context) {
      return Scaffold(
        appBar: AppBar(
          // You can now safely call BlocProvider.of<PostBloc>(context)
        ),
        // rest of your UI here
      );
    },
  ),
);

When navigating to a screen that needs the same bloc instance, use BlocProvider.value:

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: BlocProvider.of<PostBloc>(context),
      child: CreatePostScreen(),
    ),
  ),
);

Dependencies

Add the following dependencies to your pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.1
  equatable: ^2.0.3
  http: ^0.13.5

Folder Structure

lib/
├── api_service.dart           # Handles API calls
├── create_post_screen.dart    # Screen to create posts
├── detail_repository.dart     # Repository for posts and todos
├── main.dart                 # Entry point and app setup
├── post_bloc.dart            # Bloc for posts
├── post_event.dart           # Events for post bloc
├── post_state.dart           # States for post bloc
├── todo_bloc.dart            # Bloc for todos
├── todo_event.dart           # Events for todo bloc
├── todo_state.dart           # States for todo bloc
├── user_bloc.dart            # Bloc for users
├── user_event.dart           # Events for user bloc
├── user_list_screen.dart     # Screen displaying users
├── user_model.dart           # User data model
├── user_repository.dart      # Repository for users
└── user_detail_screen.dart   # Screen for user details (posts + todos)

Future Improvements

    Add persistent caching for offline access.

    Implement unit and widget tests for blocs and UI.

    Add better error handling with retry options.

    Enhance UI/UX with animations and themes.

    Add user authentication and profile editing.

    Improve post creation with validation and feedback.


Thank you for checking out this project!
If you have any questions or suggestions, feel free to open an issue or contact me


