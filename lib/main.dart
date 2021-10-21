import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import 'controllers/restapi.dart' as restapi;
import 'movie_info.dart';
import 'search_movies.dart';

void main() {
  runApp(const MainMenu());
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData.dark(),
      routes: <String, WidgetBuilder>{
        '/tela_pesquisa': (BuildContext context) => Search_Movies()
      },
      home: Builder(
        builder: (context)=> Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
            ),
            body: Body(),
            floatingActionButton: FloatingActionButton.small(
                child: const Icon(Icons.search),
                onPressed: () => Navigator.of(context).pushNamed('/tela_pesquisa')
            )
        ),
      )
      );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: NowPlayingWidget()),
          Expanded(child:PopularsWidget())
        ],
      ),
    );
  }
}


class NowPlayingWidget extends StatefulWidget {
  const NowPlayingWidget({Key? key}) : super(key: key);

  @override
  _NowPlayingWidgetState createState() => _NowPlayingWidgetState();
}

class _NowPlayingWidgetState extends State<NowPlayingWidget> {
  @override

  String urlImage = new restapi.RestAPI().get_urlBaseImage();

  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.55,
      child: FutureBuilder(
        future:  new restapi.RestAPI().get_now_playing(),
        builder:(context, snapshot) {
          if(snapshot.hasData){
            var dd = json.decode(snapshot.data.toString());

            return Container(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 5.0),
              child: Column(
                children: [

                  Align(
                    alignment: Alignment.centerLeft,
                    child:

                      Text("Últimos filmes em Cartazes",
                      textAlign: TextAlign.left,

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                    ),),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: dd['results'].length,

                        itemBuilder: (BuildContext ctx, int idx){

                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Movie_Info(id_movie: dd['results'][idx]['id']))
                              );
                            },
                            child: SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                  CircleAvatar(
                                    radius: 50.0,
                                    child: Image.network(
                                    urlImage +dd['results'][idx]['backdrop_path'],

                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: 100,

                                      loadingBuilder: (ctx, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null ?
                                            loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (ctx, error, stackTrace){
                                        return Text("Error while loading");
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20.0,),
                                      Expanded(
                                        child: Text(dd['results'][idx]['title'],
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(0.0, 1.0),
                                                blurRadius: 30.0,
                                                color: Colors.white,
                                              )
                                            ],
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              )
            );

          }else{
            return Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0,0.0,0.0, 15.0),
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
                  Text("Loading now playing movies...",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18.0,
                        letterSpacing: 2.0,
                    ),),
                ],
              ),
            );
          }
        },
      )

    );
  }
}

class PopularsWidget extends StatefulWidget {
  const PopularsWidget({Key? key}) : super(key: key);

  @override
  _PopularsWidgetState createState() => _PopularsWidgetState();
}

class _PopularsWidgetState extends State<PopularsWidget> {

  String urlImage = new restapi.RestAPI().get_urlBaseImage();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.33,
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: FutureBuilder(
          future:  new restapi.RestAPI().get_now_playing(),
          builder:(context, snapshot) {
            if(snapshot.hasData){
              var dd = json.decode(snapshot.data.toString());

              return Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Column(
                    children: [

                      Align(
                        alignment: Alignment.centerLeft,
                        child:

                        Text("Populares",
                          textAlign: TextAlign.left,

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),),
                      ),
                      SizedBox(height: 10.0,),
                      Expanded(
                          child:ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dd['results'].length,
                            itemBuilder: (BuildContext ctx, int idx) {
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Movie_Info(id_movie: dd['results'][idx]['id']))
                                    );
                                  },
                                  child: SizedBox(
                                    width: 130,
                                    child: Column(
                                      children: [
                                        Card(
                                          shadowColor: Colors.white,
                                          child: Padding(
                                          padding: EdgeInsets.all(1.0),
                                          child:Image.network(
                                            urlImage +dd['results'][idx]['poster_path'],
                                            fit: BoxFit.cover,
                                            height: 180,
                                            width: 120,
                                            loadingBuilder: (ctx, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null ?
                                                         loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                         : null,
                                                ),
                                              );
                                          },
                                            errorBuilder: (ctx, error, stackTrace){
                                              return Text("Error while loading");
                                            },
                                          ),

                                        )
                                        ),
                                        Flexible(

                                            child: Text(
                                              dd['results'][idx]['title'],
                                              textAlign: TextAlign.center,

                                              style: TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                );}
                          )
                      )
                    ]
                  )
              );




            }else{
              return Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0,80.0,0.0, 15.0),
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                    Text("Loading popular movies...",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18.0,
                        letterSpacing: 2.0,
                      ),),
                  ],
                ),
              );
            }
          },
        )

    );
  }
}




