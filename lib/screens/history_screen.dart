import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Riwayat Transaksi",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
        ),
        actions: [
          Consumer<FinanceProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(Icons.calendar_month_rounded, color: Colors.blueGrey[800]),
                onPressed: () async {
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
              );
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (provider.transactions.isEmpty) {
            return Center(
              child: Text(
                "Kosong, Bre.",
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            );
          }

          // Sort by date desc
          final txList = List.from(provider.transactions);
          txList.sort((a, b) => b.date.compareTo(a.date));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: txList.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final tx = txList[index];
              final isIncome = tx.type == "Pemasukan";
              
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(
                      color: isIncome ? Colors.green : Colors.red,
                      width: 4,
                    ),
                  ),
                  boxShadow: [
                     BoxShadow(color: Colors.grey.shade100, blurRadius: 4, offset: const Offset(0,2))
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${DateFormat('d MMM').format(tx.date)} • ${tx.account}",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                              height: 1.5,
                            ),
                          ),
                          Text(
                            tx.category,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          if(tx.description.isNotEmpty)
                          Text(
                            tx.description,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                       "${isIncome ? '+' : '-'} ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits:0).format(tx.amount)}",
                       style: GoogleFonts.inter(
                         fontSize: 14,
                         fontWeight: FontWeight.bold,
                         color: isIncome ? Colors.green.shade600 : Colors.red.shade600
                       ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
