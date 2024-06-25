import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:petcare/src/constants/momo.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_repository.g.dart';

class PaymentRepository {
  const PaymentRepository();

  Future<Map<String, dynamic>> postMoMo(
      int amount, String orderId, String orderInfo) async {
    final _signature = MoMo.generateSignature(
      amount: amount,
      extraData: "",
      requestId: orderId,
      orderId: orderId,
      orderInfo: orderInfo,
    );
    final Map<String, dynamic> requestBody = {
      'partnerCode': MoMo.partnerCode,
      'accessKey': MoMo.accessKey,
      'requestId': orderId,
      'amount': amount,
      'orderId': orderId,
      'orderInfo': orderInfo,
      'redirectUrl': MoMo.redirectUrl,
      'ipnUrl': MoMo.ipnUrl,
      'extraData': "",
      'requestType': MoMo.requestType,
      'signature': _signature,
      'lang': 'en',
    };
    final response = await http.post(
      Uri.https("test-payment.momo.vn", "/v2/gateway/api/create"),
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future createStripePaymentIntent({
    required String name,
    required String address,
    required String pin,
    required String city,
    required String state,
    required String country,
    required String amount,
  }) async {
    final url = Uri.parse("https://api.stripe.com/v1/payment_intents");
    final secretKey = dotenv.env["STRIPE_SECRET_KEY"];
    final body = {
      "amount": amount,
      "currency": 'vnd',
      'automatic_payment_methods[enabled]': 'true',
      'description': "Pet Guardian Services",
      'shipping[name]': name,
      'shipping[address][line1]': address,
      'shipping[address][postal_code]': pin,
      'shipping[address][city]': city,
      'shipping[address][state]': state,
      'shipping[address][country]': country,
    };

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $secretKey",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print(json);
      return json;
    } else {
      print("error in creating Stripe payment intent!");
    }
  }
}

@riverpod
PaymentRepository paymentRepository(PaymentRepositoryRef ref) =>
    PaymentRepository();
