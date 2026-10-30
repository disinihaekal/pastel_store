## Video Penjelasan
https://youtu.be/wSnQr5UFxbA?si=GRzsF9zovBZwoIxS

# Pastel Store

Pastel Store adalah aplikasi katalog produk berbasis Flutter yang menggunakan DummyJSON API sebagai sumber data produk.

## Fitur

- Menampilkan seluruh daftar produk dari DummyJSON API.
- Menampilkan gambar, nama, harga, dan rating produk.
- Searching.
- Detail produk.
- Informasi harga, stok, rating, kategori, dan deskripsi produk.

## Komponen

- Flutter
- Dart
- DummyJSON API
- HTTP Package
- Visual Studio Code

## API

Sumber data produk menggunakan DummyJSON:

https://dummyjson.com/docs/products

Endpoint yang digunakan:

- Seluruh produk: `https://dummyjson.com/products?limit=0`
- Detail produk: `https://dummyjson.com/products/{id}`
- Pencarian produk: `https://dummyjson.com/products/search?q={query}`

## Cara Menjalankan Aplikasi

1. Clone repository.
2. Buka folder project.
3. Jalankan :

   `flutter pub get`

4. Hubungkan Android.
5. Jalankan :

   `flutter run`