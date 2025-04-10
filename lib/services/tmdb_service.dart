import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDbService {
  final String _apiKey = 'a3550a47776ac72f665accfb405362a9'; 
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-BR&page=1'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Erro ao carregar filmes populares');
    }
  }
}
