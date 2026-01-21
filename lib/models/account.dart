class AccountModel {
  final String name;
  final double balance;

  AccountModel({required this.name, required this.balance});

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      name: json['nama'] ?? '',
      balance: (json['saldo'] ?? 0).toDouble(),
    );
  }
}
