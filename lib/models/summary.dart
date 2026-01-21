class SummaryModel {
  final double totalIncome;
  final double totalOutcome;
  final double savingRate;

  SummaryModel({
    required this.totalIncome,
    required this.totalOutcome,
    required this.savingRate,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      totalIncome: (json['totalMasuk'] ?? 0).toDouble(),
      totalOutcome: (json['totalKeluar'] ?? 0).toDouble(),
      savingRate: double.tryParse(json['savingRate'].toString()) ?? 0.0,
    );
  }
}
