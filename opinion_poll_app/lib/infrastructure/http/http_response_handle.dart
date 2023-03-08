import 'dart:convert';
import 'package:http/http.dart';

import '../../data/http/http.dart';

dynamic httpResponseHandle(Response response) {
  final int statusCode = response.statusCode;
  final Map<int, dynamic> treatmentForEachStatusCode = {
    200: response.body.isNotEmpty ? jsonDecode(response.body) : null,
    204: null,
  };

  if (treatmentForEachStatusCode.containsKey(statusCode)) {
    return treatmentForEachStatusCode[statusCode];
  }

  Map<int, HttpError> httpErrorResponse = {};
  for (HttpError error in HttpError.values) {
    httpErrorResponse.addAll({error.statusCode: error});
  }

  throw httpErrorResponse[statusCode] ?? HttpError.internalServerError;
}
