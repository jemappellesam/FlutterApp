import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Rosarium',
      theme: ThemeData(
        primaryColor: const Color(0xFF6200EA),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const ProfileSelectionPage(),
    );
  }
}

class ProfileSelectionPage extends StatelessWidget {
  const ProfileSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarRadius = (screenWidth / 3 - 32) / 2;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF6200EA), Color(0xFF121212)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Quem está assistindo?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StreamingHomePage(
                                profileImage: _getProfileImage(index),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedProfileBorder(
                              imageUrl: _getProfileImage(index),
                              radius: avatarRadius,
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                _getProfileName(index),
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getProfileName(int index) {
    List<String> profiles = ['Samuel', 'Yurik', 'Julio', 'Matheus', 'Bruno', 'Luiz'];
    return profiles[index];
  }

  String _getProfileImage(int index) {
    List<String> profileImages = [
      'assets/images/perfil_samuel.jpg',
      'assets/images/perfil_yurik.jpg',
      'assets/images/perfil_julio.jpg',
      'assets/images/perfil_matheus.jpg',
      'assets/images/perfil_bruno.jpg',
      'assets/images/perfil_luiz.jpg',
    ];
    return profileImages[index];
  }
}

class StreamingHomePage extends StatefulWidget {
  final String profileImage;
  const StreamingHomePage({super.key, required this.profileImage});
  @override
  _StreamingHomePageState createState() => _StreamingHomePageState();
}

class _StreamingHomePageState extends State<StreamingHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _colorAnimation1 = ColorTween(begin: const Color(0xFF6200EA), end: const Color(0xFF03DAC6)).animate(_controller);
    _colorAnimation2 = ColorTween(begin: const Color(0xFFBB86FC), end: const Color(0xFF018786)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailPage(movieIndex: index),
                            ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              carouselImages[index],
                              width: 200,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
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
                    children: [
                      MovieCard(imageUrl: continueWatchingImages[0], height: 180),
                      MovieCard(imageUrl: continueWatchingImages[1], height: 180),
                      MovieCard(imageUrl: continueWatchingImages[2], height: 180),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String imageUrl;
  final double height;
  const MovieCard({super.key, required this.imageUrl, this.height = 180});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 120,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 3,
              color: Colors.white.withOpacity(0.3),
              child: LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MovieDetailPage extends StatefulWidget {
  final int movieIndex;
  const MovieDetailPage({super.key, required this.movieIndex});
  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final Map<int, bool> _likedMovies = {};
  final Map<int, bool> _dislikedMovies = {};

  void toggleLike(int movieIndex) {
    setState(() {
      if (_likedMovies[movieIndex] == true) {
        _likedMovies[movieIndex] = false;
      } else {
        _likedMovies[movieIndex] = true;
        _dislikedMovies[movieIndex] = false;
      }
    });
  }

  void toggleDislike(int movieIndex) {
    setState(() {
      if (_dislikedMovies[movieIndex] == true) {
        _dislikedMovies[movieIndex] = false;
      } else {
        _dislikedMovies[movieIndex] = true;
        _likedMovies[movieIndex] = false;
      }
    });
  }

  bool isLiked(int movieIndex) => _likedMovies[movieIndex] ?? false;
  bool isDisliked(int movieIndex) => _dislikedMovies[movieIndex] ?? false;

  @override
  Widget build(BuildContext context) {
    List<String> carouselImages = [
      'assets/images/filme_1.jpg',
      'assets/images/filme_2.jpg',
      'assets/images/filme_3.jpg',
      'assets/images/filme_4.jpg',
      'assets/images/filme_5.jpg',
      'assets/images/filme_6.jpg'
    ];

    List<String> movieDescriptions = [
      'Mike sente uma grande necessidade de encontrar sua mãe...',
      'Uma história audaciosa de dois colegas de quarto...',
      'Love in the Big City é um filme de 2024...',
      'Durante uma festa de aniversário em 1968...',
      'Na ilha grega de Kalokairi, Sophie...',
      'No início da década de 1970...'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes do Filme")),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF0D1B2A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(carouselImages[widget.movieIndex]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(child: PlayIconAnimation()),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  movieDescriptions[widget.movieIndex],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: isLiked(widget.movieIndex) ? Colors.green : Colors.white),
                    onPressed: () => toggleLike(widget.movieIndex),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.thumb_down,
                      color: isDisliked(widget.movieIndex) ? Colors.red : Colors.white),
                    onPressed: () => toggleDislike(widget.movieIndex),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayIconAnimation extends StatefulWidget {
  const PlayIconAnimation({super.key});
  @override
  _PlayIconAnimationState createState() => _PlayIconAnimationState();
}

class _PlayIconAnimationState extends State<PlayIconAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 999),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 11, 0, 32).withOpacity(0.8),
      end: const Color.fromARGB(255, 52, 46, 129).withOpacity(0.8),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          Icons.play_circle_filled,
          size: 60,
          color: _colorAnimation.value,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(3 * size.width / 4, size.height - 40, size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AnimatedProfileBorder extends StatefulWidget {
  final String imageUrl;
  final double radius;
  const AnimatedProfileBorder({super.key, required this.imageUrl, this.radius = 50});
  @override
  _AnimatedProfileBorderState createState() => _AnimatedProfileBorderState();
}

class _AnimatedProfileBorderState extends State<AnimatedProfileBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _colorAnimation1 = ColorTween(begin: const Color(0xFF6200EA), end: const Color(0xFF03DAC6)).animate(_controller);
    _colorAnimation2 = ColorTween(begin: const Color(0xFFBB86FC), end: const Color(0xFF018786)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [_colorAnimation1.value!, _colorAnimation2.value!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: widget.radius,
            backgroundImage: AssetImage(widget.imageUrl),
          ),
        );
      },
    );
  }
}