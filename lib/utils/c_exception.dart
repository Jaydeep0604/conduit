import 'dart:core' as cr;

abstract class CException {}

class NoRecordFoundException extends CException {
  cr.String? message;
  cr.int statusCode;
  NoRecordFoundException({this.message, this.statusCode = 404});
}

class UnAuthorizedException extends CException {
  cr.String? message;
  cr.int statusCode;
  UnAuthorizedException({required this.statusCode, required this.message});
}

class NoRegisterdException extends CException {
  cr.String? message;
  cr.int statusCode;
  NoRegisterdException({required this.statusCode, required this.message});
}

class Exception implements cr.Exception {
  final cr.String msg;
  const Exception(this.msg);

  cr.String toString() {
    return msg;
  }
}