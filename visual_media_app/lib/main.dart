import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Rosarium',
      theme: ThemeData(
        primaryColor: Color(0xFF1A237E), // Azul escuro
        scaffoldBackgroundColor: Color(0xFF0D1B2A), // Fundo escuro
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Times New Roman',
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.transparent, // Removido o fundo azul do AppBar
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          elevation: 0, // Remover a sombra do AppBar
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
          // Gradiente de fundo com a forma de onda
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
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF3F51B5), // Roxo mais claro
                    Color(0xFF1A237E), // Azul escuro
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
                  style: TextStyle(
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
                          // Navega para a próxima tela ao clicar no perfil
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StreamingHomePage(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/images/blackrose_icon.jpg'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _getProfileName(index),
                              style: TextStyle(
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
}

class StreamingHomePage extends StatelessWidget {
  const StreamingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Rosarium"),
        leading: Icon(Icons.menu),
      ),
      body: Stack(
        children: [
          // Gradiente de fundo com a forma de onda
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
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF3F51B5), // Roxo mais claro
                    Color(0xFF1A237E), // Azul escuro
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
                    itemCount: 5, // número de imagens no carrossel
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/blackrose_icon.jpg', // Imagem do asset
                            width: 200,
                            height: 250,
                            fit: BoxFit.cover,
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
                  style: TextStyle(
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
                        imageUrl: 'assets/images/blackrose_icon.jpg',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(),
                            ),
                          );
                        },
                      ),
                      MovieCard(
                        imageUrl: 'assets/images/blackrose_icon.jpg', // Outra imagem do asset
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(),
                            ),
                          );
                        },
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

class MovieCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imageUrl,
            width: 150,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Filme"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagem principal do filme
            Image.asset(
              'assets/images/blackrose_icon.jpg',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Descrição do filme
            Text(
              'The Rose é um filme de drama musical que foi lançado em 1979...',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
