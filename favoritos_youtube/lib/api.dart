import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/video.dart';

const API_KEY = 'AIzaSyDPyzwJM9BOlKtjiswEG9uBtYq5psX2O80';

class Api {
  String _search;
  String _nextToken;

  search(String search) async {
    _search = search;
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10");
    return decode(response);
  }

  nextPae() async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken");
    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decode = json.decode(response.body);

      _nextToken = decode['nextPageToken'];

      List<Video> videos =
          decode['items'].map<Video>((m) => Video.fromJson(m)).toList();
      return videos;
    } else
      throw Exception("Failed to load videos");
  }
}
