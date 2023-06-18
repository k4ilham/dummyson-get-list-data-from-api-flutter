import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    // Membuat request HTTP GET ke URL yang diberikan
    if (response.statusCode == 200) {
      // Mengecek apakah respons berhasil dengan status code 200 (OK)
      final List<dynamic> productsJson = json.decode(response.body)['products'];

      // Mendapatkan array JSON dari body respons dan mengkonversinya menjadi daftar objek Product
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      // Jika respons tidak berhasil, lemparkan Exception dengan pesan kesalahan
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Page'),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          // Mengecek status snapshot
          if (snapshot.hasData) {
            // Jika data tersedia, kita mendapatkan daftar produk dari snapshot
            final List<Product> products = snapshot.data!;

            // Membangun GridView untuk menampilkan produk
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                // Mendapatkan produk pada indeks tertentu
                final product = products[index];

                // Mengembalikan widget Card yang berisi informasi produk
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Menampilkan thumbnail produk dengan menggunakan Image.network
                      SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Menampilkan informasi produk seperti judul, kategori, brand, harga, dan rating
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.category,
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.brand,
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'Rating: ${product.rating.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            // Jika terjadi kesalahan, menampilkan pesan kesalahan di tengah layar
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          // Jika masih dalam proses memuat data, tampilkan indikator loading di tengah layar
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
