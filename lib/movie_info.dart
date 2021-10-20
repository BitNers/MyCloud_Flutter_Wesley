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
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.blue,
        ),
        body: new SingleChildScrollView(
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
                              child: Image.network(
                                urlImage + dd['backdrop_path'],
                                fit: BoxFit.cover,
                                loadingBuilder: (ctx, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (ctx, error, stackTrace) {
                                  return Text("Error while loading");
                                },
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
                                          onPressed: () {},
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
                              child: FutureBuilder(
                                  future: new restapi.RestAPI()
                                      .get_actors_by_movie_id(this.id_movie),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var dd =
                                          json.decode(snapshot.data.toString());
                                      return Expanded(
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: dd['cast'].length,
                                              itemBuilder:
                                                  (BuildContext ctx, int idx) {
                                                return SizedBox(
                                                  width: 120,
                                                  child: Column(
                                                    children: [
                                                      Card(
                                                          shadowColor:
                                                              Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    1.0),
                                                            child:
                                                                Image.network(
                                                              urlImage +
                                                                  dd?['cast']
                                                                          [idx][
                                                                      'profile_path'],
                                                              fit: BoxFit.cover,
                                                              height: 150,
                                                              width: 120,
                                                              loadingBuilder: (ctx,
                                                                  child,
                                                                  loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null)
                                                                  return child;
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              },
                                                              errorBuilder: (ctx,
                                                                  error,
                                                                  stackTrace) {
                                                                return Text(
                                                                    "Error while loading");
                                                              },
                                                            ),
                                                          )),
                                                      Flexible(
                                                          child: Column(
                                                        children: [
                                                          Text(
                                                            dd['cast'][idx][
                                                                'original_name'],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 11.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text("AS"),
                                                          Text(
                                                            dd['cast'][idx]
                                                                ['character'],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 11.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          )
                                                        ],
                                                      ))
                                                    ],
                                                  ),
                                                );
                                              }));
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
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 15.0),
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
                    })
              ],
            ),
          ),
        ),
      ),
    );

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
        body: new SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: FutureBuilder(
                  future:
                      new restapi.RestAPI().get_movie_info_by_id(this.id_movie),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var dd = json.decode(snapshot.data.toString());

                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network(
                              urlImage + dd['backdrop_path'],
                              fit: BoxFit.cover,
                              loadingBuilder: (ctx, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (ctx, error, stackTrace) {
                                return Text("Error while loading");
                              },
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
                                                  fontWeight: FontWeight.bold)),
                                          Text(dd['original_title'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: ElevatedButton(
                                        child: Text('Saber Mais',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue),
                                        ),
                                        onPressed: () {},
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
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            child: FutureBuilder(
                                future: new restapi.RestAPI()
                                    .get_actors_by_movie_id(this.id_movie),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var dd =
                                        json.decode(snapshot.data.toString());
                                    return Expanded(
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: dd['cast'].length,
                                            itemBuilder:
                                                (BuildContext ctx, int idx) {
                                              return SizedBox(
                                                width: 120,
                                                child: Column(
                                                  children: [
                                                    Card(
                                                        shadowColor:
                                                            Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  1.0),
                                                          child: Image.network(
                                                            urlImage +
                                                                dd?['cast'][idx]
                                                                    [
                                                                    'profile_path'],
                                                            fit: BoxFit.cover,
                                                            height: 150,
                                                            width: 120,
                                                            loadingBuilder: (ctx,
                                                                child,
                                                                loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  value: loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          loadingProgress
                                                                              .expectedTotalBytes!
                                                                      : null,
                                                                ),
                                                              );
                                                            },
                                                            errorBuilder: (ctx,
                                                                error,
                                                                stackTrace) {
                                                              return Text(
                                                                  "Error while loading");
                                                            },
                                                          ),
                                                        )),
                                                    Flexible(
                                                        child: Column(
                                                      children: [
                                                        Text(
                                                          dd['cast'][idx]
                                                              ['original_name'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 11.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text("AS"),
                                                        Text(
                                                          dd['cast'][idx]
                                                              ['character'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 11.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              );
                                            }));
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
        ),
      ),
    );
  }
}
