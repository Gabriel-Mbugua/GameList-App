import 'models/game.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIService{

  Future<List<Game>> getGames() async{
    final reponse = await http.get("https://api.rawg.io/api/games");
    if(reponse.statusCode == 200){
      final Map<String, dynamic> map = json.decode(reponse.body);
      final data = map['results'];
      return data.map<Game>((json) => Game.fromJson(json)).toList();
    }
  }

}