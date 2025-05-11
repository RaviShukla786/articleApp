import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/article_bloc.dart';
import '../blocs/article_event.dart';
import '../blocs/article_state.dart';
import '../screens/detail_screen.dart';
import '../widgets/article_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ArticleBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => bloc.add(SearchArticles(value)),
            ),
          ),
          Expanded(
            child: BlocBuilder<ArticleBloc, ArticleState>(
              builder: (context, state) {
                if (state is ArticleLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ArticleLoaded) {
                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                        physics: BouncingScrollPhysics(),
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad
                        }
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async => bloc.add(RefreshArticles()),
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) {
                          final article = state.articles[index];
                          final isFavorite = state.favorites.contains(article.id);
                          return ArticleCard(
                            article: article,
                            isFavorite: isFavorite,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(article: article),
                                ),
                              );
                            },
                            onFavorite: () {
                              setState(() {
                                bloc.add(ToggleFavorite(article.id));
                              });
                            },
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is ArticleError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}