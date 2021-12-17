#!bin/sh
mvn deploy:deploy-file -Dfile=ocrsdk.aar -Durl="file://." -DgroupId="com.baidu.ocr" -DartifactId="sdk" -Dversion="1.4.7"
rm ocrsdk.aar
