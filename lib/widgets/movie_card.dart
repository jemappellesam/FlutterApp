import 'package:flutter/material.dart';

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