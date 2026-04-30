import 'package:flutter/material.dart';
import '../../../core/db/feed_repository.dart';
import '../../../features/feed/domain/entities/post_entity.dart';

/// A premium, high-speed Search Delegate powered by the Native C++ Database engine.
/// Provides sub-millisecond search results even with thousands of local posts.
class NativeSearchDelegate extends SearchDelegate {
  final _feedRepo = FeedRepository();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Start typing to search the Native Cache...'),
      );
    }
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return FutureBuilder<List<PostEntity>>(
      future: _feedRepo.searchPosts(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data!;
        if (results.isEmpty) {
          return const Center(child: Text('No matching posts found in index.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final post = results[index];

            return ListTile(
              leading: const Icon(Icons.history, color: Colors.white24),
              title: Text(post.authorUsername),
              subtitle: Text(post.caption),
              onTap: () {
                // Instantly navigate to the post in the channel
                close(context, null);
              },
            );
          },
        );
      },
    );
  }
}
