import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonationStorePage extends StatefulWidget {
  const DonationStorePage({super.key});

  @override
  _DonationStorePageState createState() => _DonationStorePageState();
}

class _DonationStorePageState extends State<DonationStorePage> {
  List<Map<String, dynamic>> _trees = [];
  String _selectedType = "All";
  String _searchQuery = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrees();
  }

  Future<void> fetchTrees() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.234.59/pohon'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _trees = data
              .map((tree) => {
                    "id": tree['id'],
                    "name": tree['title'],
                    "type": tree['desc']
                        .split(' ')[0], // Assuming first word of desc is type
                    "price": double.parse(tree['harga'].toString()),
                    "stock": tree['stock'],
                    "image": tree['gambar']
                  })
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching trees: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> getFilteredTrees() {
    return _trees.where((tree) {
      bool matchesType =
          _selectedType == "All" || tree['type'] == _selectedType;
      bool matchesSearch =
          tree['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedTrees = getFilteredTrees();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation Store"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6096B4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Donation History",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildSearchBar(),
                  _buildFilterButtons(),
                  Expanded(child: _buildTreeGrid(displayedTrees)),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: const InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: Colors.black54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    Set<String> uniqueTypes =
        _trees.map((tree) => tree['type'] as String).toSet();
    List<String> types = ["All", ...uniqueTypes];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((type) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () => setState(() => _selectedType = type),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedType == type
                    ? const Color(0xFF6096B4)
                    : Colors.grey[200],
                foregroundColor:
                    _selectedType == type ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(type),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTreeGrid(List<Map<String, dynamic>> trees) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: trees.length,
      itemBuilder: (context, index) {
        final tree = trees[index];
        return Card(
          color: Colors.grey[200],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    tree['image'] ?? 'placeholder_url',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
                Text(
                  tree['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${tree['price'].toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.blue),
                    ),
                    Text(
                      "Stock: ${tree['stock']}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
