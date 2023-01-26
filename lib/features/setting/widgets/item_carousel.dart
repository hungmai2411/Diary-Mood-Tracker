import 'package:flutter/material.dart';

class ItemCarousel extends StatelessWidget {
  final String image;
  const ItemCarousel({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fitHeight,
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }
}
