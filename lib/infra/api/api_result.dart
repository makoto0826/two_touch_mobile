import 'api_error.dart';
import 'api_result_status.dart';

class ApiResult<T> {
  final ApiResultStatus status;

  final T value;

  final ApiError error;

  bool get isOk => status == ApiResultStatus.Ok;

  ApiResult({this.status, this.value, this.error});
}
