import 'dart:convert';

class BankCardResult {
  /// 唯一的log id，用于问题定位
  int logId;

  /// ```
  ///图像方向，当图像旋转时，返回该参数。
  ///* -1：未定义，
  ///* 0：正向，
  ///* 1：逆时针90度，
  ///* 2：逆时针180度，
  ///* 3：逆时针270度
  ///```
  int direction;

  /// 银行卡号
  String bankCardNumber;

  /// 有效期
  String validDate;

  /// 银行卡类型，0：不能识别; 1：借记卡; 2：贷记卡（原信用卡大部分为贷记卡）; 3：准贷记卡; 4：预付费卡
  int bankCardType;

  /// 银行名，不能识别时为空
  String bankName;

  /// 持卡人姓名，不能识别时为空
  String holderName;

  BankCardResult({
    required this.logId,
    required this.direction,
    required this.bankCardNumber,
    required this.validDate,
    required this.bankCardType,
    required this.bankName,
    required this.holderName,
  });

  factory BankCardResult.fromMap(Map<String, dynamic> map) {
    return BankCardResult(
      logId: map['log_id'],
      direction: map['direction'],
      bankCardNumber: map['result']['bank_card_number'],
      validDate: map['result']['valid_date'],
      bankCardType: map['result']['bank_card_type'],
      bankName: map['result']['bank_name'],
      holderName: map['result']['holder_name'],
    );
  }

  factory BankCardResult.fromJson(String source) =>
      BankCardResult.fromMap(json.decode(source));
}
