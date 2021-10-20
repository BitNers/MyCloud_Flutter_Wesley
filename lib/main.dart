import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:core';
import 'controllers/restapi.dart' as restapi;
import 'dart:developer';

void main() {
  runApp(const MainMenu());
}

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.blue,

        ),
          body: Body()

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
          NowPlayingWidget(),
          PopularsWidget()
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



  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future:  new restapi.RestAPI().get_now_playing(),
        builder:(context, snapshot) {
          if(snapshot.hasData){
            var dd = json.decode(snapshot.data.toString());

            return Container(
                padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
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
                  Container(
                    height: 280.0,
                    child: ListView.builder(
                        itemCount: dd['results'].length,
                        itemBuilder: (BuildContext ctx, int idx){
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(dd['results'][idx]['title']),
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
                    padding: EdgeInsets.fromLTRB(0.0,80.0,0.0, 15.0),
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
        child: FutureBuilder(
          future:  new restapi.RestAPI().get_now_playing(),
          builder:(context, snapshot) {
            if(snapshot.hasData){
              var dd = json.decode(snapshot.data.toString());

              return Container(
                  padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
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
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                            itemCount: dd['results'].length,
                            itemBuilder: (BuildContext ctx, int idx){
                              return Container(
                                height: double.infinity,
                                width: 125,

                                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal:8.0),
                                child: Column(
                                  children: [
                                    Card(

                                    shadowColor: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.all(1.0),
                                        child: Image.network(urlImage + dd['results'][idx]['poster_path']),
                                      ),
                                    ),
                                    Text(dd['results'][idx]['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                      fontSize: 11.0

                                    ),),
                                  ],
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


