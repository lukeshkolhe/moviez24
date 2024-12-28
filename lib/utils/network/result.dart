
import 'package:moviez24/utils/network/application_errors.dart';

class Result<T, M> {
  String? message;
  late T data;
  late M? metaData;
  Status? status;
  late ApplicationError? error;

  bool get isSuccess => status == Status.ok;

  Result.fromData(this.data) {
    status = Status.ok;
  }

  Result.fromError(this.error) {
    status = Status.failed;
  }

  Result.success({
    required dynamic json,
    T Function(Map<String, dynamic> json)? dataParser,
    T Function(List list)? listParser,
    M Function(Map<String, dynamic> json)? metaParser,
  }) {
    status = Status.ok;
    if (json != null && json is Map) {
      message = json['message'];

      if (json['results'] is List) {
        data = listParser!(json['results']);
      } else {
        if (json['result'] != null && json['result'] is Map) {
          data = dataParser!(json['result']);
        } else {
          data = true as T;
        }
      }
      if (metaParser != null) {
        if(json['meta'] != null) {
          metaData = metaParser(json['meta']);
        } else {
          metaData = metaParser(json as Map<String, dynamic>);
        }
      }
    } else {
      data = true as T;
    }
  }

  Result.failed(this.error) {
    status = Status.failed;
  }

  handle({
    required Function(T data) onSuccess,
    required Function(ApplicationError error) onFailure,
  }) {
    if (status == Status.ok) {
      onSuccess(data);
    } else {
      onFailure(error!);
    }
  }
}

enum Status { ok, failed }
