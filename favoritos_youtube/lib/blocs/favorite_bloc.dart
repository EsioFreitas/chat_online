import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos_youtube/models/video.dart';

class FavoriteBloc implements BlocBase {
  Map<String, Video> _favorites;

  final StreamController<Map<String, Video>> _favController =
      StreamController<Map<String, Video>>();

  Stream<Map<String, Video>> get outFav => _favController.stream;

  void toggleFavorite(Video video){
    if(_favorites.containsKey(video.id)){
      _favorites.remove(video.id);
    }else{
      _favorites[video.id] = video;
    }
    _favController.sink.add(_favorites);
  }
  @override
  void dispose() {
    _favController.close();
  }
}
