import 'package:flutter/material.dart';
import 'api_service.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  Future<Map<String, dynamic>> _fetchMovieDetails() async {
    return await ApiService.getMovieDetails(movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchMovieDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading movie details'));
          } else if (snapshot.hasData) {
            final movie = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    movie['posterUrl'],
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.movie, size: 100),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Release Date: ${movie['releaseDate']}'),
                  const SizedBox(height: 10),
                  Text('Rating: ${movie['rating']}'),
                  const SizedBox(height: 10),
                  Text(movie['synopsis']),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
