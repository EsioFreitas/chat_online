import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos_youtube/screens/home.dart';
import 'package:flutter/material.dart';

import 'blocs/favorite_bloc.dart';
import 'blocs/videos_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: VideosBloc(),
        child: BlocProvider(
          bloc: FavoriteBloc(),
          child: MaterialApp(
            title: 'FlutterTube',
            home: Home(),
          ),
        ));
  }
}
