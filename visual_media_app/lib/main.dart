import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'blackroseFlix',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.amber, // Amarelo para detalhes
        ),
        appBarTheme: AppBarTheme(
          color: Colors.black,
          iconTheme: IconThemeData(color: Colors.amber),
          titleTextStyle: TextStyle(
            color: Colors.amber,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: StreamingHomePage(),
    );
  }
}

class StreamingHomePage extends StatelessWidget {
  const StreamingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("blackroseFlix"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de conteúdo em destaque
          Container(
            height: 250,
            color: Colors.black,
            child: Center(
              child: Text(
                'Em Destaque',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Seção de filmes e séries em cartazes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Filmes e Séries',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                MovieCard(
                  imageUrl:
                  'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiFeqJdje8V8uXkpL4AQsbcNO3317Yp1C_kB6rN2JOlIsEkHlMHRENiTiVAYA7T9QNXmpShKK0F9zvYdSf5AN9A0BLhyphenhyphenk_KWZFlqxmduiQWyIGDll7AbOBS6s16oOnuBSFuhFmO1PfbN3Wg/s1600/The+Rose.jpg',
                  onTap: () {
                    // Navegar para a página de detalhes do filme
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
    );
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
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 120,
            height: 180,
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
        title: Text("The Rose"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagem principal
            Image.network(
              'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiFeqJdje8V8uXkpL4AQsbcNO3317Yp1C_kB6rN2JOlIsEkHlMHRENiTiVAYA7T9QNXmpShKK0F9zvYdSf5AN9A0BLhyphenhyphenk_KWZFlqxmduiQWyIGDll7AbOBS6s16oOnuBSFuhFmO1PfbN3Wg/s1600/The+Rose.jpg',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Descrição do filme
            Text(
              'The Rose é um filme de drama musical que foi lançado em 1979. A história segue uma cantora...',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
