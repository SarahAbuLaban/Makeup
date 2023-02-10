import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class NetworkRequests {

  static final _client = http.Client();

  Future<http.Response> getRequest({
   required final String path,
     final Map<String, dynamic> queryParameters = const {},
  }) async {
    try {
      return await _client.get(generateUri(path, queryParameters));
    } catch (e){
      print('ERROR GETTING REQUEST');
      rethrow;
    }
  }

  dynamic decodeResponse(final http.Response response){
    try {
      return jsonDecode(response.body);
    } catch (e){
      print('ERROR decoding response ${response.body}');
      return <String, dynamic>{'error': true};
    }
  }

  Uri generateUri(final String path, final Map<String, dynamic> queryParameters){
    return Uri(
      host: 'makeup-api.herokuapp.com',
      scheme: 'https',
      path: 'api/v1/$path',
      queryParameters: queryParameters
    );
  }
}
