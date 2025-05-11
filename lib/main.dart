import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/article_bloc.dart';
import 'blocs/article_event.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ArticleApp());
}

class ArticleApp extends StatelessWidget {
  const ArticleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => ArticleBloc()..add(FetchArticles()),
        child: const HomeScreen(),
      ),
    );
  }
}