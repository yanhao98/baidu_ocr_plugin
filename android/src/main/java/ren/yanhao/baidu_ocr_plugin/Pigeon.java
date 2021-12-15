// Autogenerated from Pigeon (v1.0.12), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package ren.yanhao.baidu_ocr_plugin;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class Pigeon {

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class SearchReply {
    private String result;
    public String getResult() { return result; }
    public void setResult(String setterArg) { this.result = setterArg; }

    Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("result", result);
      return toMapResult;
    }
    static SearchReply fromMap(Map<String, Object> map) {
      SearchReply fromMapResult = new SearchReply();
      Object result = map.get("result");
      fromMapResult.result = (String)result;
      return fromMapResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class SearchRequest {
    private String query;
    public String getQuery() { return query; }
    public void setQuery(String setterArg) { this.query = setterArg; }

    Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("query", query);
      return toMapResult;
    }
    static SearchRequest fromMap(Map<String, Object> map) {
      SearchRequest fromMapResult = new SearchRequest();
      Object query = map.get("query");
      fromMapResult.query = (String)query;
      return fromMapResult;
    }
  }
  private static class FlutterCallNativeApiCodec extends StandardMessageCodec {
    public static final FlutterCallNativeApiCodec INSTANCE = new FlutterCallNativeApiCodec();
    private FlutterCallNativeApiCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return SearchReply.fromMap((Map<String, Object>) readValue(buffer));
        
        case (byte)129:         
          return SearchRequest.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof SearchReply) {
        stream.write(128);
        writeValue(stream, ((SearchReply) value).toMap());
      } else 
      if (value instanceof SearchRequest) {
        stream.write(129);
        writeValue(stream, ((SearchRequest) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface FlutterCallNativeApi {
    SearchReply search(SearchRequest request);

    /** The codec used by FlutterCallNativeApi. */
    static MessageCodec<Object> getCodec() {
      return FlutterCallNativeApiCodec.INSTANCE;
    }

    /** Sets up an instance of `FlutterCallNativeApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, FlutterCallNativeApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.FlutterCallNativeApi.search", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              SearchRequest requestArg = (SearchRequest)args.get(0);
              if (requestArg == null) {
                throw new NullPointerException("requestArg unexpectedly null.");
              }
              SearchReply output = api.search(requestArg);
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static class NativeCallFlutterApiCodec extends StandardMessageCodec {
    public static final NativeCallFlutterApiCodec INSTANCE = new NativeCallFlutterApiCodec();
    private NativeCallFlutterApiCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return SearchReply.fromMap((Map<String, Object>) readValue(buffer));
        
        case (byte)129:         
          return SearchRequest.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof SearchReply) {
        stream.write(128);
        writeValue(stream, ((SearchReply) value).toMap());
      } else 
      if (value instanceof SearchRequest) {
        stream.write(129);
        writeValue(stream, ((SearchRequest) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java.*/
  public static class NativeCallFlutterApi {
    private final BinaryMessenger binaryMessenger;
    public NativeCallFlutterApi(BinaryMessenger argBinaryMessenger){
      this.binaryMessenger = argBinaryMessenger;
    }
    public interface Reply<T> {
      void reply(T reply);
    }
    static MessageCodec<Object> getCodec() {
      return NativeCallFlutterApiCodec.INSTANCE;
    }

    public void query(SearchRequest requestArg, Reply<SearchReply> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.NativeCallFlutterApi.query", getCodec());
      channel.send(new ArrayList<Object>(Arrays.asList(requestArg)), channelReply -> {
        @SuppressWarnings("ConstantConditions")
        SearchReply output = (SearchReply)channelReply;
        callback.reply(output);
      });
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", null);
    return errorMap;
  }
}
