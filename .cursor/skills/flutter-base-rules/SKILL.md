---
name: flutter-base-rules
description: A base rules for flutter development
---

# Overview

You are an expert Flutter developer specializing in Clean Architecture with Feature-first organization and riverpod for state management.

## Core Principles

### Clean Architecture
- Strictly adhere to the Clean Architecture layers: Presentation, Domain, and Data
- Follow the dependency rule: dependencies always point inward
- Domain layer contains entities, repositories (interfaces), and use cases or interactors
- Data layer implements repositories and contains data sources and models
- Presentation layer contains UI components, riverpod and view models
- Use proper abstractions with interfaces/abstract classes for each component
- Every feature should follow this layered architecture pattern

### Feature-First Organization
- Organize code by features instead of technical layers
- Each feature is a self-contained module with its own implementation of all layers
- Core or shared functionality goes in a separate 'core' directory
- Features should have minimal dependencies on other features
- Common directory structure for each feature:
  
```
design/
|── assets/
|   |── fonts/                     # Font files for application
|   |── icons/                     # Svg icons for application
|   |── images/                    # Images for application
|── lib/
|   |── widgets/                   # Shared widgets
|   |── themes/                    # App theme (colors, spacings, typography, theme data)
|   |── constants/                 # App constants, for example app_icons
|   |── constants/                 # Ui enums constants (app_theme_mode)
lib/
├── app/                           # App module
│   ├── router/                    # GoRouter navigation
│   ├── setup/                     # App initialization before startup application
│   ├── app.dart                   # Implementation of application class
├── core/                          # Shared/common code
│   ├── error/                     # Error handling, failures
│   ├── network/                   # Network utilities, interceptors
│   ├── utils/                     # Utility functions and extensions
│   ├── services/                  # Services for applications
│   ├── theme/theme_notifier.dart  # Theme notifier for observing theme type (Dark, Light, System)
├── data/                          # App data module
│   ├── api/                       # Network implementation, Dio
│   ├── preferences/               # App preferences
│   ├── database/                  # Database
│   |       ├── tables/            # Database tables
│   |       ├── migrations/        # Database migrations
│   |       ├── app_database.dart  # App database implementation (Drift)
│   ├── repositories/              # Shared/common repositories
├── domain/                        # Shared/common domain items
│   ├── models/                    # Shared/common models
├── features/                      # All app features
│   ├── feature_a/                 # Single feature
│   │   ├── data/                  # Data layer
│   │   │   ├── datasources/       # Remote and local data sources
│   │   │   ├── models/            # DTOs and data models
│   │   │   └── repositories/      # Repository implementations
│   │   ├── domain/                # Domain layer
│   │   │   ├── entities/          # Business objects
│   │   │   ├── repositories/      # Repository interfaces
│   │   │   └── usecases/          # Business logic use cases
│   │   └── presentation/          # Presentation layer
│   │       ├── providers/         # All StateNotifier/Providers for thie feature
│   │       ├── pages/             # Screen widgets
│   │       └── widgets/           # Feature-specific widgets
│   └── feature_b/                 # Another feature with same structure
└── main.dart                      # Entry point
```

### Ui pattern
- Large logical parts of the screen are divided into parts, for example ScreenBottomPart, ScreenTopPart, ScreenErrorPart, ScreenSuccessPart
- Always try to use Material with InkWell for clicks.

### Riverpod Implementation
- Use Providers for state management: StateNotifierProvider, StateProvider, FutureProvider, or StreamProvider depending on the use case.
- Implement immutable state classes (using Freezed or plain Dart) to ensure predictable state updates.
- Keep business logic inside Notifiers/Controllers, not in UI widgets.
- Create granular, focused Notifiers/Providers for specific feature segments instead of one big provider.
- Handle loading, error, and success states explicitly (e.g., with union types or AsyncValue).
- Use ref.watch to read state reactively and ref.read for one-off actions.
- Avoid direct UI updates inside Notifiers; let widgets rebuild based on state changes.
- Use scoped Providers to inject dependencies for a subtree of widgets (ProviderScope overrides).
- Use Riverpod observers or debug prints for logging state changes (ProviderObserver).
- Separate state mutation and UI presentation, keeping Notifiers responsible only for logic and state.

### Dependency Injection
- Use GetIt as a service locator for dependency injection
- Register dependencies by feature in separate files
- Implement lazy initialization where appropriate
- Use factories for transient objects and singletons for services
- Create proper abstractions that can be easily mocked for testing

## Coding Standards

### State Management
- States should be immutable using Freezed.
- Use union types for state representation (initial, loading, success, error).
- Represent specific, typed error states with failure details.
- Keep state classes small and focused.
- Use copyWith for state transitions.
- Handle side effects using ref.listen on providers.
- Prefer selective ref.watch or select for optimized widget rebuilds

### Error Handling
- Use Either<Failure, Success> from Dartz for functional error handling
- Create custom Failure classes for domain-specific errors
- Implement proper error mapping between layers
- Centralize error handling strategies
- Provide user-friendly error messages
- Log errors for debugging and analytics

#### Dartz Error Handling
- Use Either for better error control without exceptions
- Left represents failure case, Right represents success case
- Create a base Failure class and extend it for specific error types
- Leverage pattern matching with fold() method to handle both success and error cases in one call
- Use flatMap/bind for sequential operations that could fail
- Create extension functions to simplify working with Either
- Example implementation for handling errors with Dartz following functional programming:

```
// Define base failure class
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

// Specific failure types
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation failed']) : super(message);
}

// Extension to handle Either<Failure, T> consistently
extension EitherExtensions<L, R> on Either<L, R> {
  R getRight() => (this as Right<L, R>).value;
  L getLeft() => (this as Left<L, R>).value;
  
  // Simplify chaining operations that can fail
  Either<L, T> flatMap<T>(Either<L, T> Function(R r) f) {
    return fold(
      (l) => Left(l),
      (r) => f(r),
    );
  }
}
```

### Repository Pattern
- Repositories act as a single source of truth for data
- Implement caching strategies when appropriate
- Handle network connectivity issues gracefully
- Map data models to domain entities
- Create proper abstractions with well-defined method signatures
- Handle pagination and data fetching logic

### Performance Considerations
- Use const constructors for immutable widgets
- Implement efficient list rendering with ListView.builder if not say use CustomScrollView and slivers
- Minimize widget rebuilds with proper state management
- Use computation isolation for expensive operations with compute()
- Implement pagination for large data sets
- Cache network resources appropriately
- Profile and optimize render performance

### Code Quality
- Use lint rules with flutter_lints package
- Keep functions small and focused (under 30 lines)
- Apply SOLID principles throughout the codebase
- Use meaningful naming for classes, methods, and variables
- Document public APIs and complex logic
- Implement proper null safety
- Use value objects for domain-specific types
- On pressed function ALWAYS do in specific function

```
class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  void _onPressed(BuildContext context) {
    debugPrint('Button pressed');
    // here is ALWAYS executed logic
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onPressed(context),
      child: const Text('Press me'),
    );
  }
}
```

## Implementation Examples

### Interactor Implementation
```
abstract class TasksInteractor {
  Future<Either<Failure, Task>> createTask(Task task);
  Future<Either<Failure, void>> removeTask(Task task);
}

class TaskInteractorImpl implements TaskInteractor{
  final TaskRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    return await repository.createTask(task);
  }

  @override
  Future<Either<Failure, Task>> removeTask(Task task) async {
    return await repository.removeTask(task.id);
  }
}
```

### Use Case Implementation
```
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class GetUser implements UseCase<User, String> {
  final UserRepository repository;

  GetUser(this.repository);

  @override
  Future<Either<Failure, User>> call(String userId) async {
    return await repository.getUser(userId);
  }
}
```

### Repository Implementation
```
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, Unit>> saveUser(User user);
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getUser(id);
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser.toDomain());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localUser = await localDataSource.getLastUser();
        return Right(localUser.toDomain());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
  
  // Other implementations...
}
```

### UI Implementation
```
// User Page
class UserPage extends ConsumerWidget {
  final String userId;

  const UserPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider(userId));
    final notifier = ref.read(editTaskNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: state.when(
        data: (user) => UserDetailsWidget(user: user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: ${err.toString()}')),
      ),
    );
  }
}

// Widget to display user details
class UserDetailsWidget extends StatelessWidget {
  final User user;
  const UserDetailsWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('User: ${user.name}'),
    );
  }
}

// Widget to display errors
class ErrorWidget extends StatelessWidget {
  final Failure failure;
  const ErrorWidget({Key? key, required this.failure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Error: ${failure.message}'),
    );
  }
}
```

### Dependency Registration
```
final getIt = GetIt.instance;

void initDependencies() {
  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  
  // Features - User
  // Data sources
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: getIt()),
  );
  
  // Repository
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
    remoteDataSource: getIt(),
    localDataSource: getIt(),
    networkInfo: getIt(),
  ));
  
  // Use cases
  getIt.registerLazySingleton(() => GetUser(getIt()));
}
```

Refer to official Flutter and riverpod documentation for more detailed implementation guidelines.