// import 'package:example_code/providers/providers.dart';
// import 'package:flutter/material.dart';

// class CreatePostScreen extends ConsumerWidget {
//   const CreatePostScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final titleController = TextEditingController();
//     final bodyController = TextEditingController();
//     final createPostState = ref.watch(createPostProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Create Post')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(labelText: 'Title'),
//             ),
//             TextField(
//               controller: bodyController,
//               decoration: const InputDecoration(labelText: 'Body'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 ref.read(createPostProvider.notifier).createPost(
//                       titleController.text,
//                       bodyController.text,
//                     );
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(createPostState)),
//                 );
//               },
//               child: const Text('Submit Post'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
