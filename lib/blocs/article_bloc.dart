import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article.dart';
import 'article_event.dart';
import 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  List<Article> _allArticles = [];
  Set<int> _favorites = {};

  ArticleBloc() : super(ArticleInitial()) {
    on<FetchArticles>(_onFetchArticles);
    on<RefreshArticles>(_onFetchArticlesss);
    on<SearchArticles>(_onSearchArticles);
    on<ToggleFavorite>(_onToggleFavorite);
    _loadFavorites();
  }

  Future<void> _onFetchArticles(FetchArticles event, Emitter emit) async {
    emit(ArticleLoading());
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      final data = json.decode(response.body) as List;
      _allArticles = data.map((json) => Article.fromJson(json)).toList();
      emit(ArticleLoaded(_allArticles, _favorites));
    } catch (_) {
      emit(ArticleError("Failed to load articles"));
    }
  }

  Future<void> _onFetchArticlesss(RefreshArticles event, Emitter emit) async {
    emit(ArticleLoading());
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      final data = json.decode(response.body) as List;
      _allArticles = data.map((json) => Article.fromJson(json)).toList();
      emit(ArticleLoaded(_allArticles, _favorites));
    } catch (_) {
      emit(ArticleError("Failed to load articles"));
    }
  }

  void _onSearchArticles(SearchArticles event, Emitter emit) {
    final results = _allArticles
        .where((a) => a.title.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(ArticleLoaded(results, _favorites));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter emit) async {
    if (_favorites.contains(event.articleId)) {
      _favorites.remove(event.articleId);
    } else {
      _favorites.add(event.articleId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites.map((e) => e.toString()).toList());
    emit(ArticleLoaded(_allArticles, _favorites));
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorites') ?? [];
    _favorites = favs.map((id) => int.parse(id)).toSet();
  }
}