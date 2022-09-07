#!bin/sh
# SDK下载：https://ai.baidu.com/sdk#ocr

# 用maven把aar打包成本地仓库
# 参考：
# https://www.kikt.top/posts/flutter/plugin/flutter-sdk-import-aar/
# https://www.jianshu.com/p/f5a22d983909
# https://www.cyjay.fun/index.php/archives/127/

mvn deploy:deploy-file -Dfile=ocrsdk.aar -Durl="file://." -DgroupId="com.baidu.ocr" -DartifactId="sdk" -Dversion="2.0.1"
