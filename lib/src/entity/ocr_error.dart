import '../pigeon.dart';

class OCRError implements Exception {
  int errorCode;
  String message;

  OCRError({
    required this.errorCode,
    required this.message,
  });

  factory OCRError.fromNativeResponse(OCRErrorResponseData nativeResponse) {
    return OCRError(
      errorCode: nativeResponse.errorCode!,
      message: nativeResponse.errorMessage!,
    );
  }
}
