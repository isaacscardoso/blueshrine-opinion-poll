import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';
import './http.dart';

class HttpAdapter implements HttpClient {
  late Client client;

  HttpAdapter(this.client);

  @override
  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
    final Map<String, String> defaultHeaders =
        headers?.cast<String, String>() ?? {}
          ..addAll({
            'content-type': 'application/json',
            'accept': 'application/json',
          });

    final String? jsonBody = body != null ? jsonEncode(body) : null;
    late Map<String, dynamic> httpMethodsResponse;

    try {
      httpMethodsResponse = {
        'post': client.post(
          Uri.parse(url),
          headers: defaultHeaders,
          body: jsonBody,
        ),
      };
    } catch (error) {
      throw HttpError.internalServerError;
    }

    final response = await httpMethodsResponse[method] ?? Response('', 500);
    return httpResponseHandle(response);
  }
}
