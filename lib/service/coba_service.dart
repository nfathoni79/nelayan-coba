import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nelayan_coba/model/coba_album.dart';

class CobaService {
  static Future<CobaAlbum> fetchAlbum() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      return CobaAlbum.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}