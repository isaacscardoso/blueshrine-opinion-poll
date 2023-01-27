import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

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
          ..addAll(
            {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          );

    final String? jsonBody = body != null ? jsonEncode(body) : null;
    final Map httpMethodsResponse = {
      'post': client.post(
        Uri.parse(url),
        headers: defaultHeaders,
        body: jsonBody,
      ),
    };

    final response = await httpMethodsResponse[method] ?? Response('', 500);
    return _responseHandle(response);
  }

  dynamic _responseHandle(Response response) {
    final int statusCode = response.statusCode;
    final Map<int, dynamic> treatmentForEachStatusCode = {
      200: response.body.isNotEmpty ? jsonDecode(response.body) : null,
      204: null,
    };

    const Map<int, HttpError> httpErrorResponse = {
      400: HttpError.badRequest,
      401: HttpError.unauthorized,
      403: HttpError.forbidden,
      404: HttpError.notFound,
      500: HttpError.internalServerError,
    };

    if (treatmentForEachStatusCode.containsKey(statusCode)) {
      return treatmentForEachStatusCode[statusCode];
    }

    throw httpErrorResponse[statusCode] ?? HttpError.internalServerError;
  }
}
