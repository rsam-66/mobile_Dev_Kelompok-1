import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'shop_screen.dart';
import 'profile_screen.dart';
import 'news.dart';
import 'donation_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const baseUrl = 'http://192.168.234.59:80'; // Removed :80
  List<Barang> recommendedItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendedItems();
  }

  Future<void> fetchRecommendedItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/barang'));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          recommendedItems = data.map((item) => Barang.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showErrorSnackBar('Error: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(),
      home: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF6096B4),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6096B4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 4.0,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/asset/logo_rz.png", // Updated asset path
            height: 40,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error), // Added error handler
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Color(0xFF6096B4)),
                onPressed: () {},
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/default_avatar.png'), // Changed to local asset
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWelcomeCard(),
        const SizedBox(height: 16),
        _buildCategoryButtons(),
        const SizedBox(height: 16),
        _buildBanner(),
        const SizedBox(height: 16),
        _buildRecommendedSection(),
        const SizedBox(height: 16),
        _buildActionCards(),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: const AssetImage(
                'assets/default_avatar.png'), // Changed to local asset
            onBackgroundImageError: (exception, stackTrace) =>
                const Icon(Icons.error), // Added error handler
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Mr. Alex',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Welcome!',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      children: [
        _buildCategoryButton(
            "Donate", () => _navigateTo(const DonationStorePage())),
        const SizedBox(width: 8),
        _buildCategoryButton("News", () => _navigateTo(const NewsPage())),
        const SizedBox(width: 8),
        _buildCategoryButton("Cart", () => _navigateTo(const ShopScreen())),
      ],
    );
  }

  Widget _buildCategoryButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
        ),
        child: Text(label),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: CachedNetworkImageProvider(
            "https://80000hours.org/wp-content/uploads/2022/10/sea-ocean-sky-night-cosmos-view-826635-pxhere.com_-scaled.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: const Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              "How can we help the world?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommended for you",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : recommendedItems.isEmpty
                  ? const Center(child: Text('No items available'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedItems.length,
                      itemBuilder: (context, index) =>
                          ItemCard(barang: recommendedItems[index]),
                    ),
        ),
      ],
    );
  }

  Widget _buildActionCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionCard("Boost your exp", Icons.local_florist),
        _buildActionCard("Buy accessories", Icons.shopping_cart),
      ],
    );
  }

  Widget _buildActionCard(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Barang barang;

  const ItemCard({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          const SizedBox(height: 8),
          _buildItemDetails(context),
          const SizedBox(height: 8),
          _buildBuyButton(context),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = '$_HomePageState.baseUrl/uploads/${barang.gambar}';
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildItemDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          barang.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'Stock: ${barang.stock}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Rp ${barang.harga.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildBuyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ShopScreen()),
        ),
        child: const Text(
          "Buy Now",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
