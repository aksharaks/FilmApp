import 'package:film/favourite_screen.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'movie_detail_screen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> movieResults = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMovies() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        movieResults = [];
      });
      return; // Prevent search when input is empty
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final results = await ApiService.searchMovies(_searchController.text);
      setState(() {
        movieResults = results;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        movieResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      movieResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Movie Search App',
    style: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white, // Set the text color to white
    ),
  ),
  centerTitle: true,
  backgroundColor: Colors.blue, // Set the AppBar background color
),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for a movie...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onSubmitted: (_) => _searchMovies(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchMovies,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Loading Indicator
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
            // Display message when no results are found
            if (!_isLoading && movieResults.isEmpty && _searchController.text.isNotEmpty)
              const Center(child: Text('No results found')),
            // List View for Search Results
            Expanded(
              child: ListView.builder(
                itemCount: movieResults.length,
                itemBuilder: (context, index) {
                  final movie = movieResults[index];
                  return ListTile(
                    leading: Image.network(
                      movie['posterUrl'],
                      width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.movie, size: 50),
                    ),
                    title: Text(movie['title']),
                    subtitle: Text('Release Date: ${movie['releaseDate']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movieId: movie['id']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.favorite),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
          );
        },
      ),
    );
  }
}
