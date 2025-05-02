
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpodlearn/post_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/posts',
  routes: [
    // Route to view posts
    GoRoute(
      path: '/posts',
      builder: (context, state) => const PostsScreen(),
    ),
    // Route to create a new post
    GoRoute(
      path: '/create-post',
      builder: (context, state) {
        // Extract the title from the query parameters using Uri
        final Uri uri = state.uri; // Access the uri from state
        final title = uri.queryParameters['title'] ??
            ''; // Get the 'title' query parameter
        return CreatePostScreen(title: title); // Pass title to CreatePostScreen
      },
    ),
  ],
);

class PostsScreen extends ConsumerWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('GET Posts')),
      body: postState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : postState.error.isNotEmpty
              ? Center(child: Text(postState.error))
              : ListView.builder(
                  itemCount: postState.posts.length,
                  itemBuilder: (context, index) {
                    final post = postState.posts[index]; // Get the Post object
                    return ListTile(
                      title: Text(post.title), // Access title from Post
                      subtitle: Text(post.body), // Access body from Post
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final postTitle = postState.posts.first
              .title; // Get the title of the first post or you can pass a selected title
          context.go('/create-post?title=$postTitle');
        },
        // => context.go('/create-post'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreatePostScreen extends ConsumerWidget {
  final String title; // Title received from the previous screen

  const CreatePostScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController =
        TextEditingController(text: title); // Set the title in the controller
    final bodyController = TextEditingController();

    // Watch the state of the createPostProvider for success or error messages
    final createPostState = ref.watch(createPostProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('POST Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // First: make the API call
                await ref.read(createPostProvider.notifier).createPost(
                      titleController.text,
                      bodyController.text,
                    );

                // Now read the latest updated createPostState
                final newState = ref.read(createPostProvider);

                // Show SnackBar feedback after post creation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(newState.isNotEmpty ? newState : 'No message'),
                    duration: const Duration(seconds: 2),
                  ),
                );

                // Clear fields if successfully created
                if (newState.startsWith('Post created')) {
                  titleController.clear();
                  bodyController.clear();
                }
              },
              child: const Text('Submit Post'),
            ),
            const SizedBox(height: 20),
            if (createPostState.startsWith('Post created'))
              const Text(
                '✅ Your post has been successfully created!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            if (createPostState.startsWith('Error'))
              Text(
                '❌ Failed to create post.\n${createPostState.replaceFirst('Error: ', '')}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
