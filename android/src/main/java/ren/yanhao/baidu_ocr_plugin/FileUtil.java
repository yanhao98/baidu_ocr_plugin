/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package ren.yanhao.baidu_ocr_plugin;

import android.content.Context;

import java.io.File;
import java.io.FileOutputStream;

public class FileUtil {
    public static File getSaveFile(Context context) {
        return new File(context.getFilesDir(), "recognize.jpg");
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    public static void saveFile(Context context, byte[] data) {
        File file = getSaveFile(context);
        try {
            file.createNewFile();
            FileOutputStream out = new FileOutputStream(file);
            out.write(data);
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
