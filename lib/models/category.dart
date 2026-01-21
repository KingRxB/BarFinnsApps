class CategoryModel {
  final String name;
  final String type;
  final double budget;
  final double used;

  CategoryModel({
    required this.name,
    required this.type,
    required this.budget,
    required this.used,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['nama'] ?? '',
      type: json['jenis'] ?? '',
      budget: (json['anggaran'] ?? 0).toDouble(),
      used: (json['terpakai'] ?? 0).toDouble(),
    );
  }

  double get percentage => budget == 0 ? 0 : (used / budget) * 100;
}
