import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'controllers/restapi.dart' as restapi;

class Movie_Info extends StatelessWidget {
  final int id_movie;

  const Movie_Info({Key? key, required this.id_movie}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String urlImage = new restapi.RestAPI().get_urlBaseImage();

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                FutureBuilder(
                    future: new restapi.RestAPI()
                        .get_movie_info_by_id(this.id_movie),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        var dd = json.decode(snapshot.data.toString());

                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CachedNetworkImage(
                                imageUrl: urlImage + dd['backdrop_path'].toString(),
                                placeholder: (ctx, url) => Container(child: CircularProgressIndicator()),
                                errorWidget: (ctx, url, error) => ImageIcon(AssetImage("images/not_found.png")),

                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.purple,
                                child: Container(
                                  height: 90,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(dd['title'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(dd['original_title'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: ElevatedButton(
                                          child: Text('Saber Mais',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.blue),
                                          ),
                                          onPressed: ()=> new restapi.RestAPI().launchURLBrowser("https://google.com.br/search?q=${dd['title']}%20filme"),
                                        )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    dd['overview'],
                                    textAlign: TextAlign.justify,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .48,
                              child: FutureBuilder(
                                  future: new restapi.RestAPI()
                                      .get_actors_by_movie_id(this.id_movie),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var dd =
                                          json.decode(snapshot.data.toString());
                                      return SizedBox(
                                        child: Column(
                                          children: [

                                            Align(
                                              alignment: Alignment.centerLeft,

                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                                child: Text("Atores & Elenco", textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                )),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30.0,
                                            ),
                                            Expanded(
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: dd['cast'].length,
                                                    itemBuilder:
                                                        (BuildContext ctx, int idx) {
                                                          return Card(

                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [

                                                                  CachedNetworkImage(
                                                                    imageUrl: urlImage + dd['cast'][idx]['profile_path'].toString(),
                                                                    placeholder: (ctx, url) => Container(child: CircularProgressIndicator()),
                                                                    errorWidget: (ctx, url, error) => ImageIcon(AssetImage("images/nan_actor.png")),
                                                                    height: 190,
                                                                    width: 120,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(dd['cast'][idx]['original_name'], textAlign: TextAlign.center,),
                                                                      Text("COMO", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w200)),
                                                                      Text(dd['cast'][idx]['character'], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                    )
                                                      ),
                                          ],
                                        ),
                                      );

                                    } else {
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Center(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0.0, 0.0, 0.0, 15.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Text(
                                                  "Loading actors...",
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
                            )
                          ],
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                    })
              ],
            ),
          ),
        ),
      ),
    );

  }

}
