class PaymentMethodModel {
  String? key;
  String? paymentMethod;
  int amount;

  PaymentMethodModel({
    this.key,
    required this.paymentMethod,
    required this.amount,
  });

  // get model from json
  factory PaymentMethodModel.fromJson(Map json) {
    return PaymentMethodModel(
      key: json['_id'],
      paymentMethod: json['paymentMethod'] ?? '',
      amount: json['amount'] ?? 0,
    );
  }

  // get json from model
  Map toJson() {
    return {
      'paymentMethod': paymentMethod,
      'amount': amount,
    };
  }
}
