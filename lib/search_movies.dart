import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextField(
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        decoration:
        InputDecoration(
           fillColor: Colors.blue.shade600,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),) ,
          title: typing ? TextBox() : Text(""),
          backgroundColor: Colors.blue,

        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Spacer(),
              Text("Aqui vai um loading inicial."),
              Spacer()
            ],
          ),
        ),
      );

  }
}
