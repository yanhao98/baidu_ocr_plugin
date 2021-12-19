import 'dart:convert';

import 'package:recase/recase.dart';

enum ImageStatus {
  /// 识别正常
  normal,

  /// 身份证正反面颠倒
  reversedSide,

  /// 上传的图片中不包含身份证
  nonIdcard,

  /// 身份证模糊
  blurred,

  /// 其他类型证照
  otherTypeCard,

  /// 身份证关键字段反光或过曝
  overExposure,

  /// 身份证欠曝（亮度过低）
  overDark,

  /// 未知状态
  unknown,
}

class IdCardResult {
  /// 图像方向
  ImageStatus imageStatus;

  /// ```
  ///图像方向，当图像旋转时，返回该参数。
  ///* -1：未定义，
  ///* 0：正向，
  ///* 1：逆时针90度，
  ///* 2：逆时针180度，
  ///* 3：逆时针270度
  ///```
  int direction;

  /// 唯一的log id，用于问题定位
  int logId;

  /// 身份证反面信息
  IdCardResultBack back;

  /// 身份证正面信息
  IdCardResultFront front;

  IdCardResult({
    required this.imageStatus,
    required this.direction,
    required this.logId,
    required this.back,
    required this.front,
  });

  factory IdCardResult.fromMap(Map<String, dynamic> map) {
    return IdCardResult(
      imageStatus: ImageStatus.values.byName(ReCase(map['image_status']).camelCase),
      direction: map['direction'],
      logId: map['log_id'],
      back: IdCardResultBack.fromMap(map),
      front: IdCardResultFront.fromMap(map),
    );
  }

  factory IdCardResult.fromJson(String source) => IdCardResult.fromMap(json.decode(source));
}

class IdCardResultBack {
  /// 签发日期
  String signDate;

  /// 失效日期
  String expiryDate;

  /// 签发机关
  String issueAuthority;

  IdCardResultBack({
    required this.signDate,
    required this.expiryDate,
    required this.issueAuthority,
  });

  factory IdCardResultBack.fromMap(Map<String, dynamic> map) {
    return IdCardResultBack(
      signDate: map['words_result']?['签发日期']?['words'] ?? '',
      expiryDate: map['words_result']?['失效日期']?['words'] ?? '',
      issueAuthority: map['words_result']?['签发机关']?['words'] ?? '',
    );
  }

  factory IdCardResultBack.fromJson(String source) => IdCardResultBack.fromMap(json.decode(source));
}

class IdCardResultFront {
  /// 姓名
  String name;

  /// 民族
  String ethnic;

  /// 住址
  String address;

  /// 公民身份号码
  String idNumber;

  /// 出生
  String birthday;

  /// 性别
  String gender;

  ///```
  ///用于校验身份证号码、性别、出生是否一致，输出结果及其对应关系如下：
  ///* -1： 身份证正面所有字段全为空
  ///* 0： 身份证证号不合法，此情况下不返回身份证证号
  ///* 1： 身份证证号和性别、出生信息一致
  ///* 2： 身份证证号和性别、出生信息都不一致
  ///* 3： 身份证证号和出生信息不一致
  ///* 4： 身份证证号和性别信息不一致
  ///```
  int idcardNumberType;

  IdCardResultFront({
    required this.name,
    required this.ethnic,
    required this.address,
    required this.idNumber,
    required this.birthday,
    required this.gender,
    required this.idcardNumberType,
  });
  factory IdCardResultFront.fromMap(Map<String, dynamic> map) {
    return IdCardResultFront(
      name: map['words_result']?['姓名']?['words'] ?? '',
      ethnic: map['words_result']?['民族']?['words'] ?? '',
      address: map['words_result']?['住址']?['words'] ?? '',
      idNumber: map['words_result']?['公民身份号码']?['words'] ?? '',
      birthday: map['words_result']?['出生']?['words'] ?? '',
      gender: map['words_result']?['性别']?['words'] ?? '',
      idcardNumberType: map['idcard_number_type'] ?? -1,
    );
  }

  factory IdCardResultFront.fromJson(String source) => IdCardResultFront.fromMap(json.decode(source));
}
