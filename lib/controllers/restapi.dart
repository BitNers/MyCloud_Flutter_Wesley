import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

class RestAPI {
  String _language = "";
  String _api_key  = "";
  String _urlBase  = "";
  String _urlBaseImage = "";
  String _parameters = "";
  Map<String, String> _endpoints = const <String, String>{};

  RestAPI(){
    this._urlBase = "https://api.themoviedb.org/3";
    this._urlBaseImage = "https://image.tmdb.org/t/p/w500/";
    this._api_key = "f02f27dcc375a0f273bfc120a646e037";
    this._language = "pt-BR";
    this._parameters = "?api_key=${this._api_key}&language=${this._language}";

    this._endpoints = {
      "popular": "/movie/popular?api_key=${this._api_key}&language=${this._language}&page=1",
      "now_playing": "/movie/now_playing?api_key=${this._api_key}&language=${this._language}&page=1",
      "get_movie_details": "/movie/%d?api_key=${this._api_key}&language=${this._language}",
      "get_movie_images": "/movie/%d/images?api_key=${this._api_key}&language=${this._language}"
    };
  }

  String get_urlBaseImage(){return this._urlBaseImage;}

  Future <String> get_now_playing() async {

    var url = Uri.parse("${this._urlBase}${this._endpoints['now_playing']}");
    final httpResponse = await http.get(url);

    if(httpResponse.statusCode == 200){
      return httpResponse.body;

    }else{
      return "<Erro>";
    }


  }


  Future <String> get_popular_movies() async {

    var url = Uri.parse("${this._urlBase}${this._endpoints['popular']}");
    final httpResponse = await http.get(url);

    if(httpResponse.statusCode == 200){
      return httpResponse.body;

    }else{
      return "<Erro>";
    }


  }


}