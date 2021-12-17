package ren.yanhao.baidu_ocr_plugin;

import androidx.annotation.NonNull;

import java.io.IOException;

public class PluginException extends Throwable {
    private final String message;


    public PluginException(
            String message) {
        this.message = message;
    }

    @NonNull
    public String toString() {
        return message;
    }
}
