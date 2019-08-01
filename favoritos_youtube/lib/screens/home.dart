import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos_youtube/blocs/videos_bloc.dart';
import 'package:favoritos_youtube/delegates/data_search.dart';
import 'package:favoritos_youtube/tiles/video_tile.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 60,
          child: Image.asset("images/youtube.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text('0'),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null && result.isNotEmpty) {
                BlocProvider.of<VideosBloc>(context).inSearch.add(result);
                print('oi');
                print(result.length);
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
          initialData: [],
          stream: BlocProvider.of<VideosBloc>(context).outVideos,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return ListView.builder(
                  itemCount: snapshot.data.length + 1,
                  itemBuilder: (context, index) {
                    if (index < snapshot.data.length)
                      return VideoTile(snapshot.data[index]);
                    else if (index > 1) {
                      BlocProvider.of<VideosBloc>(context).inSearch.add(null);
                      return Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red)),
                      );
                    }
                  });
            else
              return Container();
          }),
    );
  }
}
