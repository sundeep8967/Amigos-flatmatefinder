import 'package:flutter/material.dart';
import '../models/flat_model.dart';

class FlatDetailsScreen extends StatelessWidget {
  final FlatModel flat;

  const FlatDetailsScreen({
    super.key,
    required this.flat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(flat.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.orange,
            ),
            SizedBox(height: 16),
            Text(
              'Flat Details Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Under Construction',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Flat: ${flat.title}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Price: \$${flat.price}/month',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}