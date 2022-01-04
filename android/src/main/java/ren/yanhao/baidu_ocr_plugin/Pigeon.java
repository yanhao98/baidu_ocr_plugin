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
  public static class InitWithAkSkRequestData {
    private String ak;
    public String getAk() { return ak; }
    public void setAk(String setterArg) { this.ak = setterArg; }

    private String sk;
    public String getSk() { return sk; }
    public void setSk(String setterArg) { this.sk = setterArg; }

    Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("ak", ak);
      toMapResult.put("sk", sk);
      return toMapResult;
    }
    static InitWithAkSkRequestData fromMap(Map<String, Object> map) {
      InitWithAkSkRequestData fromMapResult = new InitWithAkSkRequestData();
      Object ak = map.get("ak");
      fromMapResult.ak = (String)ak;
      Object sk = map.get("sk");
      fromMapResult.sk = (String)sk;
      return fromMapResult;
    }
  }

  public interface Result<T> {
    void success(T result);
    void error(Throwable error);
  }
  private static class OcrHostApiCodec extends StandardMessageCodec {
    public static final OcrHostApiCodec INSTANCE = new OcrHostApiCodec();
    private OcrHostApiCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return InitWithAkSkRequestData.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof InitWithAkSkRequestData) {
        stream.write(128);
        writeValue(stream, ((InitWithAkSkRequestData) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface OcrHostApi {
    void initWithAkSk(InitWithAkSkRequestData request, Result<Void> result);
    void recognizeIdCardFrontNative();
    void recognizeIdCardBackNative();
    void initCameraNative();
    void releaseCameraNative();

    /** The codec used by OcrHostApi. */
    static MessageCodec<Object> getCodec() {
      return OcrHostApiCodec.INSTANCE;
    }

    /** Sets up an instance of `OcrHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, OcrHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.OcrHostApi.initWithAkSk", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              InitWithAkSkRequestData requestArg = (InitWithAkSkRequestData)args.get(0);
              if (requestArg == null) {
                throw new NullPointerException("requestArg unexpectedly null.");
              }
              Result<Void> resultCallback = new Result<Void>() {
                public void success(Void result) {
                  wrapped.put("result", null);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.initWithAkSk(requestArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.OcrHostApi.recognizeIdCardFrontNative", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.recognizeIdCardFrontNative();
              wrapped.put("result", null);
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
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.OcrHostApi.recognizeIdCardBackNative", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.recognizeIdCardBackNative();
              wrapped.put("result", null);
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
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.OcrHostApi.initCameraNative", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.initCameraNative();
              wrapped.put("result", null);
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
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.OcrHostApi.releaseCameraNative", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.releaseCameraNative();
              wrapped.put("result", null);
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
  private static class RecognizeListenerFlutterApiCodec extends StandardMessageCodec {
    public static final RecognizeListenerFlutterApiCodec INSTANCE = new RecognizeListenerFlutterApiCodec();
    private RecognizeListenerFlutterApiCodec() {}
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java.*/
  public static class RecognizeListenerFlutterApi {
    private final BinaryMessenger binaryMessenger;
    public RecognizeListenerFlutterApi(BinaryMessenger argBinaryMessenger){
      this.binaryMessenger = argBinaryMessenger;
    }
    public interface Reply<T> {
      void reply(T reply);
    }
    static MessageCodec<Object> getCodec() {
      return RecognizeListenerFlutterApiCodec.INSTANCE;
    }

    public void onReceivedStart(Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.RecognizeListenerFlutterApi.onReceivedStart", getCodec());
      channel.send(null, channelReply -> {
        callback.reply(null);
      });
    }
    public void onReceivedResult(String resultArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.RecognizeListenerFlutterApi.onReceivedResult", getCodec());
      channel.send(new ArrayList<Object>(Arrays.asList(resultArg)), channelReply -> {
        callback.reply(null);
      });
    }
    public void onReceivedError(String descriptionArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.RecognizeListenerFlutterApi.onReceivedError", getCodec());
      channel.send(new ArrayList<Object>(Arrays.asList(descriptionArg)), channelReply -> {
        callback.reply(null);
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
