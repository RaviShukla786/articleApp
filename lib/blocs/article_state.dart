import 'package:equatable/equatable.dart';
import '../models/article.dart';

abstract class ArticleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ArticleInitial extends ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final List<Article> articles;
  final Set<int> favorites;

  ArticleLoaded(this.articles, this.favorites);

  @override
  List<Object?> get props => [articles, favorites];
}

class ArticleError extends ArticleState {
  final String message;
  ArticleError(this.message);

  @override
  List<Object?> get props => [message];
}