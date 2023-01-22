import 'package:dio/dio.dart';
import 'package:nike/constants/exception.dart';

mixin HttpResponseValidator {
  validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }
}
