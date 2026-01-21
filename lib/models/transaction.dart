class TransactionModel {
  final String id;
  final DateTime date;
  final String type; // Pemasukan / Pengeluaran
  final String account;
  final String category;
  final double amount;
  final String description;

  TransactionModel({
    required this.id,
    required this.date,
    required this.type,
    required this.account,
    required this.category,
    required this.amount,
    required this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      date: DateTime.parse(json['tanggal']),
      type: json['tipe'] ?? '',
      account: json['rekening'] ?? '',
      category: json['kategori'] ?? '',
      amount: (json['nominal'] ?? 0).toDouble(),
      description: json['desk'] ?? '',
    );
  }
}
