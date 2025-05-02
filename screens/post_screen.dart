// import 'package:flutter/material.dart';

// class PostsScreen extends ConsumerWidget {
//   const PostsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final postState = ref.watch(postProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Posts')),
//       body: postState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : postState.error.isNotEmpty
//               ? Center(child: Text(postState.error))
//               : ListView.builder(
//                   itemCount: postState.posts.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(postState.posts[index].title),
//                       subtitle: Text(postState.posts[index].body),
//                     );
//                   },
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           ref.read(postProvider.notifier).fetchPosts();
//         },
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
