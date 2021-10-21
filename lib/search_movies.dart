
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'controllers/restapi.dart' as restapi;
import 'dart:convert';
import 'movie_info.dart';

TextEditingController searchController = new TextEditingController();


class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,// MediaQuery.of(context).size.width,
      child: TextField(
        controller: searchController,
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        textAlignVertical: TextAlignVertical.center,
        decoration:
        InputDecoration(
           fillColor: Colors.blueGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0)
            ),

            hintText: 'Procure pelo seu filme',
            alignLabelWithHint: true),
      ),
    );
  }
}

class Search_Movies extends StatefulWidget {
  const Search_Movies({Key? key}) : super(key: key);

  @override
  _SearchMoviesState createState() => _SearchMoviesState();
}

class _SearchMoviesState extends State<Search_Movies> {
  bool typing = true;
  String urlImage = new restapi.RestAPI().get_urlBaseImage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),),


          title: typing ? TextBox() : Text(""),
          backgroundColor: Colors.blue,

        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.all(6.0),
          child: FutureBuilder(
          future: new restapi.RestAPI().get_movie_by_name(searchController.text),
          builder: (context, snapshot){
          if(snapshot.hasData){

            if((snapshot.data.toString().contains("Erro")) && (searchController.text.isEmpty)) {
              return Container(
                padding: EdgeInsets.all(5.0),
                child: Center(child: Text("Erro ao acessar o Banco de Dados.")),
              );
            }
            else{

              if((snapshot.data.toString().contains("ErroCliente")) || (snapshot.data.toString().contains("ErroServidor"))){
                return Container(
                  padding: EdgeInsets.all(5.0),
                  child: Center(child: Text("Houve um erro na sua requisição... :(", textAlign: TextAlign.center,))
                );
              };


              var dd = json.decode(snapshot.data.toString());

              if(dd['results'].length == 0){
                return Container(
                    padding: EdgeInsets.all(5.0),
                    child: Center(child: Text("Nenhum filme encontrado... :(", textAlign: TextAlign.center,))
                );
              }


              return Container(
                padding: EdgeInsets.all(3.0),
                child: Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: dd['results'].length,
                    itemBuilder: (ctx, idx){
                      return GestureDetector(
                        onTap: ()=>{
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Movie_Info(id_movie: dd['results'][idx]['id']))
                        )
                        },
                        child: SizedBox(
                          child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 45.0,
                                      child: CachedNetworkImage(
                                        imageUrl: urlImage + dd['results'][idx]['poster_path'].toString(),
                                        placeholder: (ctx, url) => Container(child: CircularProgressIndicator()),
                                        errorWidget: (ctx, url, error) => ImageIcon(AssetImage("images/nan_actor.png")),

                                        height: 120,
                                        width: 100,
                                        fit: BoxFit.cover,
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
                              )
                          ),
                        ),
                      );
                    },


                  ),
                ),
              );

            }
          }else{
            return Container(
              width: double.infinity,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.red,
                    ),

                    Text("Carregando sua pesquisa...",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18.0,
                          letterSpacing: 2.0,
                        )),
                  ]
              ),
            );
          }
        },
        ),
      )
      );
  }
}