import 'package:flutter/foundation.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../models/summary.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';

class FinanceProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  SummaryModel? _summary;
  SummaryModel? get summary => _summary;

  List<AccountModel> _accounts = [];
  List<AccountModel> get accounts => _accounts;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  String? _error;
  String? get error => _error;

  // Filter Dates
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  void setDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    fetchData();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getAllData(
        startDate: _startDate,
        endDate: _endDate,
      );

      if (data['error'] != null) {
        _error = data['error'];
      } else {
        _summary = SummaryModel.fromJson(data['summary']);
        
        _accounts = (data['rekening'] as List)
            .map((e) => AccountModel.fromJson(e))
            .toList();
            
        _categories = (data['kategori'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
            
        _transactions = (data['transaksi'] as List)
            .map((e) => TransactionModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction({
    required String type,
    required String account,
    required String category,
    required double amount,
    required String description,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final payload = {
        "action": "tambah_transaksi",
        "tipe": type,
        "rekening": account,
        "kategori": category,
        "nominal": amount,
        "deskripsi": description
      };
      await _apiService.addTransaction(payload);
      // Refresh data
      await fetchData();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
