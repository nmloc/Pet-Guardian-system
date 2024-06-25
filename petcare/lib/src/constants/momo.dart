import 'dart:convert';
import 'package:crypto/crypto.dart';

class MoMo {
  static String secretKey = "at67qH6mk8w5YInAyMoYKMWACiEi2bsa";
  static String partnerCode = "MOMOBKUN20180529";
  static String accessKey = "kIm05TvNBzhg7h7j";
  static String requestType = "captureWallet";
  static String ipnUrl = "com.nmloc.petcare://testScreen";
  static String redirectUrl = "com.nmloc.petcare://testScreen";

  static String generateSignature({
    required int amount,
    required String extraData,
    required String requestId,
    required String orderId,
    required String orderInfo,
  }) {
    final data =
        'accessKey=$accessKey&amount=$amount&extraData=$extraData&ipnUrl=$ipnUrl&orderId=$orderId&orderInfo=$orderInfo&partnerCode=$partnerCode&redirectUrl=$redirectUrl&requestId=$requestId&requestType=$requestType';
    return Hmac(sha256, utf8.encode(secretKey))
        .convert(utf8.encode(data))
        .toString();
  }
}
