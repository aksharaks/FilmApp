import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = '2aa2986ee3daca01225f4bbc9f029ed2';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  // Fetch movies based on search query
  static Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    // Encode the query to handle special characters
    final encodedQuery = Uri.encodeQueryComponent(query);

    // Construct the URL with the encoded query
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$encodedQuery');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if 'results' is empty
        if (data['results'].isEmpty) {
          return [];
        }

        List<Map<String, dynamic>> movies = (data['results'] as List)
            .map((movie) => {
                  'id': movie['id'].toString(),
                  'title': movie['title'] ?? 'No Title',
                  'releaseDate': movie['release_date'] ?? 'Unknown',
                  'posterUrl': movie['poster_path'] != null
                      ? 'https://image.tmdb.org/t/p/w200${movie['poster_path']}'
                      : '',
                })
            .toList();

        return movies;
      } else {
        throw Exception('Failed to fetch movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  // Fetch movie details by movie ID
  static Future<Map<String, dynamic>> getMovieDetails(String movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final movie = jsonDecode(response.body);

        return {
          'title': movie['title'] ?? 'No Title',
          'synopsis': movie['overview'] ?? 'No Synopsis Available',
          'releaseDate': movie['release_date'] ?? 'Unknown',
          'rating': movie['vote_average']?.toString() ?? 'N/A',
          'posterUrl': movie['poster_path'] != null
              ? 'https://image.tmdb.org/t/p/w300${movie['poster_path']}'
              : '',
        };
      } else {
        throw Exception('Failed to fetch movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }
}
