enum HttpError {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  internalServerError,
  badGateway,
}

extension HttpErrorStatusCode on HttpError {
  int get statusCode {
    switch (this) {
      case HttpError.badRequest:
        return 400;
      case HttpError.unauthorized:
        return 401;
      case HttpError.forbidden:
        return 403;
      case HttpError.notFound:
        return 404;
      case HttpError.internalServerError:
        return 500;
      case HttpError.badGateway:
        return 502;
    }
  }
}
