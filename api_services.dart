import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:riverpodlearn/provider_model.dart';
// Make sure to import the Post model

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Get posts - Returns List<Post> instead of List<dynamic>
  Future<List<Posts>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));

      // Log status code and url
      log('GET ${response.request?.url} -> ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Log a sample post title for quick verification
        if (data.isNotEmpty) {
          log('First Post Title: ${data.first['title']}');
        }

        // Parse the list and return
        return data.map((item) => Posts.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to load posts. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching posts: $e');
      throw Exception('Failed to load posts: $e');
    }
  }

  // Create a post - Returns the created post as a Map<String, dynamic>
  Future<Posts> createPost(String title, String body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': title,
        'body': body,
        'id': 101,
        'userId': 10, // You can keep userId if you want to associate it.
      }),
    );

    if (response.statusCode == 201) {
      log("Response2: ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Posts.fromJson(data);
    } else {
      throw Exception('Failed to create post');
    }
  }
}
