/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 */
package ren.yanhao.baidu_ocr_plugin;

import android.content.Context;

import java.io.File;

public class FileUtil {
  public static File getSaveFile(Context context) {
    return new File(context.getFilesDir(), "recognize.jpg");
  }
}
