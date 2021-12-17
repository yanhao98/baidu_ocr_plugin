import 'package:pigeon/pigeon.dart';

class InitWithAkSkRequestData {
  String? ak;
  String? sk;
}

@HostApi()
abstract class OcrHostApi {
  @async
  void initWithAkSk(InitWithAkSkRequestData request);
}
