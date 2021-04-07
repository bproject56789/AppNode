class ApiResult<T> {
  final T message;
  final bool isFailure;

  bool get isSuccess => !isFailure;

  ApiResult({this.message, this.isFailure});

  factory ApiResult.success(T message) {
    return ApiResult(message: message, isFailure: false);
  }

  factory ApiResult.successWithNoMessage() {
    return ApiResult(isFailure: false);
  }

  factory ApiResult.failure(T message) {
    return ApiResult(message: message, isFailure: true);
  }
}
