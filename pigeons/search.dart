import 'package:pigeon/pigeon.dart';

/// flutter call native
@HostApi()
abstract class FlutterCallNativeApi {
  SearchReply search(SearchRequest request);
}

/// native call flutter
@FlutterApi()
abstract class NativeCallFlutterApi {
  SearchReply query(SearchRequest request);
}

class SearchReply {
  String? result;
}

class SearchRequest {
  String? query;
}
