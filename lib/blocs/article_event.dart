import 'package:equatable/equatable.dart';

abstract class ArticleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchArticles extends ArticleEvent {}

class RefreshArticles extends ArticleEvent {}

class SearchArticles extends ArticleEvent {
  final String query;
  SearchArticles(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleFavorite extends ArticleEvent {
  final int articleId;
  ToggleFavorite(this.articleId);

  @override
  List<Object?> get props => [articleId];
}