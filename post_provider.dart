import 'dart:developer';
// import 'package:example_code/model/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodlearn/api_services.dart';
import 'package:riverpodlearn/provider_model.dart';

// -------- PostState ---------
class PostState {
  final List<Posts> posts;
  final bool isLoading;
  final String error;

  PostState({
    this.posts = const [],
    this.isLoading = false,
    this.error = '',
  });

  PostState copyWith({
    List<Posts>? posts,
    bool? isLoading,
    String? error,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// -------- PostNotifier for GET ---------
class PostNotifier extends StateNotifier<PostState> {
  final ApiService apiService;

  PostNotifier(this.apiService) : super(PostState()) {
    // Fetch posts automatically when the notifier is created
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      state = state.copyWith(isLoading: true, error: '');

      // Call the updated ApiService fetchPosts
      final posts = await apiService.fetchPosts();

      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      log('Error fetching posts: $e');
      state = state.copyWith(error: 'Failed to load posts', isLoading: false);
    }
  }
}

// -------- CreatePostNotifier for POST ---------x
class CreatePostNotifier extends StateNotifier<String> {
  final ApiService apiService;

  CreatePostNotifier(this.apiService) : super('');

  Future<void> createPost(String title, String body) async {
    try {
      final post = await apiService.createPost(title, body);
      state = 'Post created with ID: ${post.id}';
    } catch (e) {
      log('Error creating post: $e');
      state = 'Error: ${e.toString()}';
    }
  }
}

// -------- Providers ---------
final postProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  return PostNotifier(ApiService());
});

final createPostProvider =
    StateNotifierProvider<CreatePostNotifier, String>((ref) {
  return CreatePostNotifier(ApiService());
});
