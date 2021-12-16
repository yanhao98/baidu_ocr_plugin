import 'package:pigeon/pigeon.dart';

class SearchReply {
  String? result;
}

class SearchRequest {
  String? query;
}

/// flutter call native
@HostApi()
abstract class FlutterCallNativeApi {
  @async
  void replyErrorFromNative();

  SearchReply search(SearchRequest request);

  @async
  SearchReply startAsyncSearch();

  void endAsyncSearch();
}

/// native call flutter
@FlutterApi()
abstract class NativeCallFlutterApi {
  SearchReply query(SearchRequest request);
}
