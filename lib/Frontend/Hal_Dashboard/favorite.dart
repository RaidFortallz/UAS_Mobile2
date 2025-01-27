import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/favorite_provider.dart';
import 'package:uas_mobile2/Models/coffee_model.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
          body: favoriteProvider.favorites.isEmpty
          ? const Center(
              child: Text('Belum ada kopi favorit!'),
            )
          : ListView.builder(
              itemCount: favoriteProvider.favorites.length,
              itemBuilder: (context, index) {
                Coffees coffee = favoriteProvider.favorites[index];
                return ListTile(
                  leading: Image.network(
                    coffee.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(coffee.name),
                  subtitle: Text(coffee.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      favoriteProvider.removeFavorite(coffee);
                    },
                  ),
                );
              },
            ),
    );
  }
}
