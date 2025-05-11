import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(article.title),
        subtitle: Text(article.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: Icon(isFavorite ? Icons.star : Icons.star_border,color: isFavorite ? Colors.amberAccent : Colors.black,),
          onPressed: onFavorite,
        ),
        onTap: onTap,
      ),
    );
  }
}