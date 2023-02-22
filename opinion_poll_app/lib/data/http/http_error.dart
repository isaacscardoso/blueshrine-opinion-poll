enum HttpError {
  badRequest('400 - Bad Request'),
  unauthorized('401 - Unauthorized'),
  forbidden('403 - Forbidden'),
  notFound('404 - Not Found'),
  internalServerError('500 - Internal Server Error'),
  badGateway('502 - Bad Gateway');

  final String description;

  const HttpError(this.description);

  get statusCode {
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
