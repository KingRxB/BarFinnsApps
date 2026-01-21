import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>(); // Not strictly used but good practice
  
  String _type = "Pengeluaran";
  String? _account;
  String? _category;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
         title: Text(
          "Catat Baru",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<FinanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
             return const Center(child: CircularProgressIndicator());
          }

          // Populate dropdowns if empty (though logic handles nulls)
          // Ideally rely on loaded data.
          final accOptions = provider.accounts.map((e) => e.name).toList();
          final catOptions = provider.categories.map((e) => e.name).toList();
          
          // Defaults if null
          if(_account == null && accOptions.isNotEmpty) _account = accOptions.first;
          if(_category == null && catOptions.isNotEmpty) _category = catOptions.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0,5))
                ],
                border: Border.all(color: Colors.grey.shade100)
              ),
              child: Column(
                children: [
                  _buildDropdown(
                    label: "Tipe Transaksi",
                    value: _type,
                    items: ["Pengeluaran", "Pemasukan"],
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                  const SizedBox(height: 16),
                   _buildDropdown(
                    label: "Rekening",
                    value: _account,
                    items: accOptions.isEmpty ? ["Loading..."] : accOptions,
                    onChanged: (v) => setState(() => _account = v),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: "Kategori",
                    value: _category,
                    items: catOptions.isEmpty ? ["Loading..."] : catOptions,
                    onChanged: (v) => setState(() => _category = v),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey.shade50,
                      hintText: "Nominal Rp",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(16)
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descController,
                     style: GoogleFonts.inter(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey.shade50,
                      hintText: "Keterangan...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(16)
                    ),
                  ),
                   const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(_amountController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nominal wajib diisi")));
                          return;
                        }
                        try {
                           await provider.addTransaction(
                             type: _type,
                             account: _account ?? "",
                             category: _category ?? "",
                             amount: double.parse(_amountController.text),
                             description: _descController.text
                           );
                           if(mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Disimpan!")));
                             _amountController.clear();
                             _descController.clear();
                             // Navigate back or reset?
                           }
                        } catch(e) {
                           if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                      ),
                      child: Text("SIMPAN DATA", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          isExpanded: true,
          hint: Text(label),
          items: items.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
