import 'package:flutter/material.dart';
import '../widgets/movie_card.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/wave_clipper.dart';
import 'movie_detail_screen.dart';
import '../services/tmdb_service.dart';

class StreamingHomeScreen extends StatefulWidget {
  final String profileImage;
  const StreamingHomeScreen({super.key, required this.profileImage});

  @override
  State<StreamingHomeScreen> createState() => _StreamingHomeScreenState();
}

class _StreamingHomeScreenState extends State<StreamingHomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  List<String> carouselImages = [
    'assets/images/filme_1.jpg',
    'assets/images/filme_2.jpg',
    'assets/images/filme_3.jpg',
    'assets/images/filme_4.jpg',
    'assets/images/filme_5.jpg',
    'assets/images/filme_6.jpg'
  ];

  List<String> continueWatchingImages = [
    'assets/images/continua_assistindo_1.jpg',
    'assets/images/continua_assistindo_2.jpg',
    'assets/images/continua_assistindo_3.jpg',
  ];

  List<dynamic> _popularMovies = [];
  bool _isLoadingPopular = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _colorAnimation1 = ColorTween(begin: const Color(0xFF6200EA), end: const Color(0xFF03DAC6)).animate(_controller);
    _colorAnimation2 = ColorTween(begin: const Color(0xFFBB86FC), end: const Color(0xFF018786)).animate(_controller);

    _loadPopularMovies();
  }

  void _loadPopularMovies() async {
    try {
      final movies = await TMDbService().getPopularMovies();
      setState(() {
        _popularMovies = movies;
        _isLoadingPopular = false;
      });
    } catch (e) {
      print('Erro ao carregar filmes populares: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Rosarium"),
        leading: const Icon(Icons.menu),
        flexibleSpace: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_colorAnimation1.value!, _colorAnimation2.value!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6200EA), Color(0xFF121212)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6200EA).withOpacity(0.8),
                    const Color(0xFF121212).withOpacity(0.8)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: carouselImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              carouselImages[index],
                              width: 200,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Continue assistindo',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: continueWatchingImages.map((image) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: MovieCard(imageUrl: image, height: 180),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Populares',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 280,
                    child: _isLoadingPopular
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _popularMovies.length,
                            itemBuilder: (context, index) {
                              final movie = _popularMovies[index];
                              final imageUrl = movie['poster_path'] != null
                                  ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                                  : null;
                              final title = movie['title'] ?? 'Sem título';
                              final rating = movie['vote_average']?.toStringAsFixed(1) ?? '-';

                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetailScreen(movie: movie),
                                      ),
                                    );
                                  },
                                  child: imageUrl != null
                                      ? SizedBox(
                                          width: 140,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.network(
                                                  imageUrl,
                                                  width: 140,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '⭐ $rating',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

