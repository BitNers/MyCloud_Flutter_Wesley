import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controllers/restapi.dart' as restapi;

class Movie_Info extends StatelessWidget {
  final int id_movie;

  const Movie_Info({Key? key, required this.id_movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String urlImage = new restapi.RestAPI().get_urlBaseImage();

    return MaterialApp(
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.blue,
          ),
          body: SafeArea(
            child: Container(
              child: FutureBuilder(
                  future:
                      new restapi.RestAPI().get_movie_info_by_id(this.id_movie),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var dd = json.decode(snapshot.data.toString());

                      return Column(
                        children: [
                          Image.network(
                            urlImage + dd['backdrop_path'],
                          ),
                          Row(),
                          Row(),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  "Loading info about the movie...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18.0,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ),
        ));
  }
}
