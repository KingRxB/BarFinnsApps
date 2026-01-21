import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FinanceProvider>().fetchData();
    });
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Setup a nice background
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.summary == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          return RefreshIndicator(
            onRefresh: provider.fetchData,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  _buildHeader(provider),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTotalBalanceCard(provider),
                        const SizedBox(height: 16),
                        _buildHealthCard(provider),
                        const SizedBox(height: 16),
                        _buildBudgetRef(provider),
                        const SizedBox(height: 16),
                        _buildCategoryChart(provider),
                        const SizedBox(height: 16),
                        _buildAccountsList(provider),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(FinanceProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BarFinns Dashboard",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  "BaraCash",
                  style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: DateTimeRange(
                          start: provider.startDate,
                          end: provider.endDate,
                        ),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.blue.shade600,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        provider.setDateRange(picked.start, picked.end);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy').format(provider.startDate),
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(Icons.arrow_right_alt, color: Colors.white70, size: 16),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(provider.endDate),
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                  onPressed: provider.fetchData,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTotalBalanceCard(FinanceProvider provider) {
    double totalSaldo = 0;
    for (var acc in provider.accounts) {
      totalSaldo += acc.balance;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 5))
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Text(
            "TOTAL SALDO LU",
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatCurrency(totalSaldo),
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.blueGrey.shade900,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text("INCOME",
                          style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600)),
                      Text(formatCurrency(provider.summary?.totalIncome ?? 0),
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text("OUTCOME",
                          style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade600)),
                      Text(formatCurrency(provider.summary?.totalOutcome ?? 0),
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700)),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHealthCard(FinanceProvider provider) {
    final rate = provider.summary?.savingRate ?? 0;
    Color bg;
    String msg;

    if (rate >= 20) {
      bg = Colors.green.shade600;
      msg = "Gila, Bre! Saving rate lu mantap (>=20%). Keuangan lu sehat banget, lanjutin nabungnya biar rumah Bali cepet kebeli!";
    } else if (rate > 0) {
      bg = Colors.orange.shade500;
      msg = "Masih aman, Bre, tapi tipis. Coba cek lagi pengeluaran yang nggak penting biar saving rate bisa tembus 20%.";
    } else {
      bg = Colors.red.shade600;
      msg = "Waduh! Lu 'Besar Pasak daripada Tiang', Bre. Pengeluaran lu lebih gede dari pemasukan. Bahaya buat jangka panjang!";
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: bg.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "EVALUASI RASIO KEUANGAN",
                style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                "$rate%",
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            msg,
            style: GoogleFonts.inter(
                fontSize: 11, color: Colors.white.withOpacity(0.9), height: 1.4),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "SAVING RATE LU BULAN INI",
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.6)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBudgetRef(FinanceProvider provider) {
    if (provider.categories.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SISTEM ANGGARAN",
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ...provider.categories.where((c) => c.budget > 0).map((c) {
            Color color;
            if (c.percentage > 90) {
              color = Colors.red;
            } else if (c.percentage > 70) {
              color = Colors.orange;
            } else {
              color = Colors.blue;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(c.name,
                          style: GoogleFonts.inter(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                      Text(
                        "${c.percentage.toStringAsFixed(0)}% (${formatCurrency(c.used)} / ${formatCurrency(c.budget)})",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: c.percentage > 90 ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: c.percentage > 100 ? 1 : c.percentage / 100,
                      backgroundColor: Colors.grey.shade100,
                      color: color,
                      minHeight: 6,
                    ),
                  )
                ],
              ),
            );
          }).toList(),
          if (provider.categories.every((c) => c.budget == 0))
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                    child: Text("Belum ada anggaran yang di-set di Google Sheets.",
                        style: TextStyle(fontSize: 10, color: Colors.grey)))),
        ],
      ),
    );
  }

  Widget _buildCategoryChart(FinanceProvider provider) {
    if (provider.categories.isEmpty) return const SizedBox.shrink();
    
    // Prepare Data
    final outcomeCats = provider.categories.where((c) => c.type == 'Pengeluaran' && c.used > 0).toList();
    if(outcomeCats.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
         color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            "OUTCOME CATEGORY",
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade400,
             letterSpacing: 1.5,
            ),
          ),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: outcomeCats.asMap().entries.map((e) {
                  final index = e.key;
                  final cat = e.value;
                  final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
                  
                  return PieChartSectionData(
                    color: colors[index % colors.length],
                    value: cat.used,
                    title: '',
                    radius: 50,
                  );
                }).toList(),
              ),
            ),
          ),
           Wrap(
            spacing: 8,
            children: outcomeCats.asMap().entries.map((e){
               final index = e.key;
               final cat = e.value;
               final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
               return Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Container(width: 8, height: 8, color: colors[index % colors.length]),
                   const SizedBox(width: 4),
                   Text(cat.name, style: const TextStyle(fontSize: 10)),
                 ]
               );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildAccountsList(FinanceProvider provider) {
      if(provider.accounts.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
           border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
             Text(
              "DETAIL PER REKENING",
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ...provider.accounts.map((a) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade50))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(a.name, style: GoogleFonts.inter(fontSize: 13, color: Colors.blueGrey.shade700)),
                  Text(formatCurrency(a.balance), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
                ],
              ),
            )).toList()
          ],
        ),
      );
  }
}
