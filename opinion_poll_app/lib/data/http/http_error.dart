enum HttpError {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  internalServerError,
  badGateway,
}

extension HttpErrorStatusCode on HttpError {
  int? get statusCode {
    const codes = {
      HttpError.badRequest: 400,
      HttpError.unauthorized: 401,
      HttpError.forbidden: 403,
      HttpError.notFound: 404,
      HttpError.internalServerError: 500,
      HttpError.badGateway: 502,
    };
    return codes[this];
  }
}
