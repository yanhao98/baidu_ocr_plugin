#!bin/sh
# 参考: wakelock
# https://github.com/flutter/packages/tree/master/packages/pigeon/example
flutter pub run pigeon \
    --input pigeons/messages.dart \
    --dart_out lib/src/pigeon.dart \
    --objc_header_out ios/Classes/messages.h \
    --objc_source_out ios/Classes/messages.m \
    --java_out ./android/src/main/java/ren/yanhao/baidu_ocr_plugin/Pigeon.java \
    --java_package "ren.yanhao.baidu_ocr_plugin"
