# BarFinns (Duitku Pro)

Aplikasi manajemen keuangan pribadi berbasis Flutter dengan backend Google Sheets (via Google Apps Script).

[Screenshot atau Logo akan muncul di sini]

## Fitur

- **Dashboard**: Melihat ringkasan saldo, pemasukan, pengeluaran, dan saving rate.
- **Analisis**: Visualisasi pengeluaran per kategori.
- **Riwayat**: Daftar transaksi dengan filter tanggal.
- **Input Mudah**: Tambah transaksi baru yang langsung tersinkronisasi ke Google Sheets.
- **Multi-Akun**: Mendukung banyak rekening (BCA, Mandiri, Tunai, e-Wallet, dll).

## Persiapan (Backend)

Aplikasi ini membutuhkan backend Google Apps Script.

1.  Buka [Google Sheets](https://sheets.google.com).
2.  Buat Spreadsheet baru dengan 3 Sheet: `Transaksi`, `Saldo`, `Kategori`.
    - **Transaksi**: Kolom A-G (ID, Tanggal, Tipe, Rekening, Kategori, Nominal, Deskripsi).
    - **Saldo**: Kolom A-B (Nama Rekening, Saldo Awal).
    - **Kategori**: Kolom A-C (Nama, Jenis, Anggaran).
3.  Buka **Extensions** > **Apps Script**.
4.  Copy kode backend (hubungi pemilik repo untuk template `code.gs` atau buat sendiri sesuai API yang dibutuhkan).
5.  **Deploy** sebagai Web App:
    - Execute as: **Me**
    - Who has access: **Anyone**
6.  Salin **Deployment URL** yang diberikan.

## Cara Menjalankan (Flutter)

1.  Clone repo ini.
2.  Buka `lib/services/api_service.dart`.
3.  Ganti `YOUR_GOOGLE_APPS_SCRIPT_URL_HERE` dengan URL Web App Anda.
4.  Jalankan perintah:
    ```bash
    flutter pub get
    flutter run
    ```

## Build APK

Untuk membuat file APK release:

```bash
flutter build apk --release
```

File output: `build/app/outputs/flutter-apk/app-release.apk`
