import 'package:flutter/material.dart';

import 'product.dart';
import 'product_service.dart';
import 'product_detail_page.dart';

void main() {
  runApp(const PastelStoreApp());
}

const Color pastelBg = Color(0xFFFFF9F4);
const Color pastelPurple = Color(0xFFE9DDF7);
const Color pastelMint = Color(0xFFDDF3E4);
const Color pastelPink = Color(0xFFF9DFE7);
const Color pastelPeach = Color(0xFFFFE7D5);
const Color ink = Color(0xFF393448);

class PastelStoreApp extends StatelessWidget {
  const PastelStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pastel Store',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pastelBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB6A0DB),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const ProductHomePage(),
    );
  }
}

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({super.key});

  @override
  State<ProductHomePage> createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {
  final ProductService service = ProductService();
  final TextEditingController searchController = TextEditingController();

  List<Product> products = [];
  bool loading = true;
  String? errorMessage;
  String query = '';

  @override
  void initState() {
    super.initState();
    loadProducts();
    searchController.addListener(onSearchChanged);
  }

  Future<void> loadProducts() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final result = await service.getProducts();
      if (!mounted) return;

      setState(() {
        products = result;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Tidak bisa memuat produk. Periksa internet.';
        loading = false;
      });
    }
  }

  void onSearchChanged() {
    final value = searchController.text.trim();
    setState(() {
      query = value;
    });
  }

  List<Product> get filteredProducts {
    if (query.isEmpty) return products;

    final keyword = query.toLowerCase();

    return products.where((product) {
      return product.title.toLowerCase().contains(keyword) ||
          product.category.toLowerCase().contains(keyword) ||
          product.description.toLowerCase().contains(keyword);
    }).toList();
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = filteredProducts;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: pastelPurple,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          color: ink,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'pastel store',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: ink,
                              ),
                            ),
                            Text(
                              'Find something lovely',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: ink,
                        size: 27,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: pastelPurple, width: 1.3),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari produk favoritmu...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF8B79B5),
                        ),
                        suffixIcon: query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: searchController.clear,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Explore products',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: ink,
                          ),
                        ),
                      ),
                      if (!loading)
                        Text(
                          '${visibleProducts.length} items',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off_rounded,
                              size: 50,
                              color: ink,
                            ),
                            const SizedBox(height: 12),
                            Text(errorMessage!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: loadProducts,
                              child: const Text('Coba lagi'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : visibleProducts.isEmpty
                  ? const Center(child: Text('Produk tidak ditemukan.'))
                  : RefreshIndicator(
                      onRefresh: loadProducts,
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: visibleProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 13,
                              mainAxisSpacing: 13,
                              childAspectRatio: 0.61,
                            ),
                        itemBuilder: (context, index) {
                          final product = visibleProducts[index];
                          final colors = [
                            pastelPurple,
                            pastelMint,
                            pastelPink,
                            pastelPeach,
                          ];
                          final cardColor = colors[index % colors.length];

                          return InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailPage(productId: product.id),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: cardColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: BorderRadius.circular(17),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        product.thumbnail,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (
                                              context,
                                              error,
                                              stackTrace,
                                            ) => const Center(
                                              child: Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                size: 40,
                                                color: ink,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      3,
                                      12,
                                      12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.category.toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 9,
                                            letterSpacing: 0.7,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            height: 1.25,
                                            fontWeight: FontWeight.w700,
                                            color: ink,
                                          ),
                                        ),
                                        const SizedBox(height: 9),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Color(0xFFE5A74F),
                                              size: 15,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              product.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: ink,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF7964A8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
