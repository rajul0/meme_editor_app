# 🚀 Meme Editor Flutter App

Aplikasi Meme Editor sederhana menggunakan Flutter, BLoC Pattern, dan Hive.

---

## 🛠️ Requirements

- Flutter SDK (minimal versi sesuai project, cek pubspec.yaml)
- Dart SDK
- Android Studio / VSCode / Terminal
- Emulator atau Perangkat Fisik
- Hive, BLoC, CachedNetworkImage, dan package lain (otomatis di-install)

---

## 📥 Cara Fetch dan Jalankan Project

### 1. Clone Project dari Repository

```bash
git clone
```

---

### 2. Masuk ke Folder Project

```bash
cd nama-project
```

---

### 3. Install Dependencies

```bash
flutter pub get
```

---

### 4. Generate File yang Dibutuhkan (Jika Pakai build_runner)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Biasanya diperlukan jika project pakai `hive_generator` atau `json_serializable`.

---

### 5. Jalankan Project

```bash
flutter run
```

Pilih emulator atau device yang tersedia.

---

## 💡 Catatan Tambahan

- Pastikan Hive sudah ter-initialize di main.dart.
- Jika error terkait permission di Android, cek AndroidManifest.
- Jika pakai API, pastikan link API aktif.
- Untuk testing offline mode, aktifkan toggle offline di aplikasi.

---

## 📦 Build APK (Opsional)

```bash
flutter build apk --release
```

---

## 📊 Status

Project ini masih dalam tahap pengembangan.

---

## 💎 Credits

Dibangun menggunakan Flutter , BLoC Pattern & Clean Architecture.

---

👇 Silakan modifikasi README ini sesuai kebutuhan spesifik project kamu.
