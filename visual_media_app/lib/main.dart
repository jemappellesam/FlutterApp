import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Rosarium',
      theme: ThemeData(
        primaryColor: Color(0xFF6200EA), // Roxo vibrante
        scaffoldBackgroundColor: Color(0xFF121212), // Fundo escuro moderno
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: ProfileSelectionPage(),
    );
  }
}

class ProfileSelectionPage extends StatelessWidget {
  const ProfileSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradiente de fundo
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6200EA), // Roxo vibrante
                  Color(0xFF121212), // Fundo escuro
                ],
              ),
            ),
          ),
          // Efeito de vidro fosco no topo
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF6200EA).withOpacity(0.8),
                    Color(0xFF121212).withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título "Quem está assistindo?"
                Text(
                  "Quem está assistindo?",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Lista de Perfis
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: 6, // 6 perfis
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navega para a tela de streaming ao clicar no perfil
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StreamingHomePage(
                                profileImage: _getProfileImage(index), // Passa a imagem do perfil
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(_getProfileImage(index)), // Exibe a imagem correta
                            ),
                            SizedBox(height: 10),
                            Text(
                              _getProfileName(index),
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
    // Aqui você mapeia o perfil com a imagem correspondente
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

class _StreamingHomePageState extends State<StreamingHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Duração reduzida para 2 segundos
    )..repeat(reverse: true);

    // Cores mais contrastantes
    _colorAnimation1 = ColorTween(
      begin: Color(0xFF6200EA), // Roxo vibrante
      end: Color(0xFF03DAC6), // Ciano brilhante
    ).animate(_controller);

    _colorAnimation2 = ColorTween(
      begin: Color(0xFFBB86FC), // Roxo claro
      end: Color(0xFF018786), // Verde-água escuro
    ).animate(_controller);
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
        title: Text("The Rosarium"),
        leading: Icon(Icons.menu),
        flexibleSpace: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _colorAnimation1.value!,
                    _colorAnimation2.value!,
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Gradiente de fundo
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6200EA), // Roxo vibrante
                  Color(0xFF121212), // Fundo escuro
                ],
              ),
            ),
          ),
          // Efeito de vidro fosco no topo
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF6200EA).withOpacity(0.8),
                    Color(0xFF121212).withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carrossel de Imagens
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: carouselImages.length, // número de imagens no carrossel
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navega para a tela de detalhes do filme
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailPage(
                                  movieIndex: index,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              carouselImages[index], // Imagem do asset
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
                SizedBox(height: 20),
                // Título da seção alterado
                Text(
                  'Continue assistindo',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                // Lista horizontal de filmes e séries
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      MovieCard(
                        imageUrl: continueWatchingImages[0],
                      ),
                      MovieCard(
                        imageUrl: continueWatchingImages[1],
                      ),
                      MovieCard(
                        imageUrl: continueWatchingImages[2],
                      ),
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

class MovieDetailPage extends StatelessWidget {
  final int movieIndex;

  const MovieDetailPage({super.key, required this.movieIndex});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    List<String> carouselImages = [
      'assets/images/filme_1.jpg',
      'assets/images/filme_2.jpg',
      'assets/images/filme_3.jpg',
      'assets/images/filme_4.jpg',
      'assets/images/filme_5.jpg',
      'assets/images/filme_6.jpg'
    ];

    List<String> movieDescriptions = [
      'Descrição do Filme 1...',
      'Descrição do Filme 2...',
      'Descrição do Filme 3...',
      'Descrição do Filme 4...',
      'Descrição do Filme 5...',
      'Descrição do Filme 6...',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Filme"),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A237E), // Azul escuro
                  Color(0xFF0D1B2A), // Roxo escuro
                ],
              ),
            ),
          ),
          Column(
            children: [
              // Imagem do filme ocupando o topo da tela
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(carouselImages[movieIndex]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: PlayIconAnimation(),
                ),
              ),
              SizedBox(height: 20),
              // Descrição do filme
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  movieDescriptions[movieIndex],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              // Botões de like/dislike
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: movieProvider.isLiked(movieIndex) ? Colors.green : Colors.white,
                    ),
                    onPressed: () => movieProvider.toggleLike(movieIndex),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.thumb_down,
                      color: movieProvider.isDisliked(movieIndex) ? Colors.red : Colors.white,
                    ),
                    onPressed: () => movieProvider.toggleDislike(movieIndex),
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

class MovieProvider with ChangeNotifier {
  // Mapa para armazenar o estado de like/dislike de cada filme
  final Map<int, bool> _likedMovies = {};
  final Map<int, bool> _dislikedMovies = {};

  bool isLiked(int movieIndex) => _likedMovies[movieIndex] ?? false;
  bool isDisliked(int movieIndex) => _dislikedMovies[movieIndex] ?? false;

  void toggleLike(int movieIndex) {
    if (_likedMovies[movieIndex] == true) {
      _likedMovies[movieIndex] = false;
    } else {
      _likedMovies[movieIndex] = true;
      _dislikedMovies[movieIndex] = false; // Desativa dislike se like for ativado
    }
    notifyListeners();
  }

  void toggleDislike(int movieIndex) {
    if (_dislikedMovies[movieIndex] == true) {
      _dislikedMovies[movieIndex] = false;
    } else {
      _dislikedMovies[movieIndex] = true;
      _likedMovies[movieIndex] = false; // Desativa like se dislike for ativado
    }
    notifyListeners();
  }
}

class PlayIconAnimation extends StatefulWidget {
  const PlayIconAnimation({super.key});

  @override
  _PlayIconAnimationState createState() => _PlayIconAnimationState();
}

class _PlayIconAnimationState extends State<PlayIconAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 999),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
  begin: const Color.fromARGB(255, 11, 0, 32).withOpacity(0.8), // Roxo escuro
  end: const Color.fromARGB(255, 52, 46, 129).withOpacity(0.8), // Roxo médio
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

class MovieCard extends StatelessWidget {
  final String imageUrl;

  const MovieCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imageUrl,
          width: 150,
          height: 220,
          fit: BoxFit.cover,
        ),
      ),
    );
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
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
