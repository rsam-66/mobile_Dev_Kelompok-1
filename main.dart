import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Combined App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages
  static final List<Widget> _pages = [
    const HomePage(),
    const NewsPage(),
    const ShopScreen(),
    PaymentMethodPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Switch between HomePage and NewsPage
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
            backgroundColor: Colors.teal,
          ),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Thursday, 27 July 2024",
              style: TextStyle(color: Colors.teal),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.teal),
                  onPressed: () {},
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
                ),
                SizedBox(width: 16),
                Column(
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
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              categoryButton("All"),
              categoryButton("Donate"),
              categoryButton("News", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsPage()),
                );
              }),
              categoryButton("Cart", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopScreen()),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage(
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
          ),
          const SizedBox(height: 16),
          // Recommended section
          const Text(
            "Recommended for you",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              plantCard("Northern Red Oak", "\$2"),
              plantCard("Bristlecone Pine", "\$5"),
              plantCard("Sugar Maple", "\$10"),
            ],
          ),
          const SizedBox(height: 16),
          // Suggestions or actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              actionCard("Boost your exp", Icons.local_florist, Colors.teal),
              actionCard("Buy accessories", Icons.shopping_cart, Colors.teal),
            ],
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String label, {VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(label),
    );
  }

  Widget plantCard(String plantName, String price) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 8),
        Text(plantName),
        const SizedBox(height: 4),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Plant",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget actionCard(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  final List<Map<String, String>> newsData = const [
    {
      "title": "Amazon nations split on oil and deforestation, ahead of summit",
      "subtitle":
          "Colombia wants to restrict oil production while the Brazilian government is divided on the issue",
      "imageUrl":
          "https://www.shutterstock.com/image-illustration/colombia-brazil-flags-3d-waving-600nw-1927003892.jpg", // Correct key here
      "source": "by Reuters (Climate Home News)",
    },
    {
      "title": "Global warming hits new high in the last decade",
      "subtitle":
          "Scientists have warned that the Earth's temperature has increased dramatically",
      "imageUrl":
          "data:image/jpeg;base64,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",
      "source": "by BBC News",
    },
    {
      "title": "Efforts to restore coral reefs see new hope",
      "subtitle":
          "Marine biologists are finding new ways to protect and restore coral reefs",
      "imageUrl":
          "data:image/jpeg;base64,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",
      "source": "by National Geographic",
    },
    {
      "title": "Renewable energy adoption rises worldwide",
      "subtitle":
          "More countries are investing in solar and wind energy to combat climate change",
      "imageUrl":
          "data:image/jpeg;base64,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",
      "source": "by CNN International",
    },
    {
      "title": "Deforestation in the Amazon reaches new highs",
      "subtitle":
          "Satellite images reveal alarming rates of forest loss in 2024",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGXUaI06VgHtSM88O_o7iRXwpZYMU1trHL6w&s",
      "source": "by The Guardian",
    },
    {
      "title": "New species discovered in the depths of the Pacific",
      "subtitle": "Researchers found unique species at unexplored ocean depths",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkiKus9hf0Natr9F6BG6gZN0UqPHlGzENLpA&s",
      "source": "by Science Daily",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: const TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              icon: Icon(Icons.search, color: Colors.teal),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: newsData.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with rounded corners
                  if (newsData[index]["imageUrl"] != "-")
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        newsData[index]["imageUrl"]!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    newsData[index]["title"]!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    newsData[index]["subtitle"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Source
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      newsData[index]["source"]!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
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
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";
  bool isPopularSelected = true; // Toggle between Popular and Newest

  final List<Map<String, String>> products = [
    {'title': 'VerdeWaves - Defend', 'price': '\$20'},
    {'title': 'PalmaZen - Woodland Bracelet', 'price': '\$10'},
    {'title': 'ExcluZen Wooden Earrings', 'price': '\$15'},
    {'title': 'TimberForge Wooden Ring', 'price': '\$40'},
    {'title': 'Stone Shimmer Ring', 'price': '\$15'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thu 27 JULY',
          style: TextStyle(
            color: Colors.teal, // Ubah warna teks di sini
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We have prepared new product for you",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Search',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      searchText = _searchController.text;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isPopularSelected = true;
                    });
                  },
                  child: Text(
                    'Popular',
                    style: TextStyle(
                        fontSize: 16,
                        color: isPopularSelected ? Colors.teal : Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isPopularSelected = false;
                    });
                  },
                  child: Text(
                    'Newest',
                    style: TextStyle(
                        fontSize: 16,
                        color: !isPopularSelected ? Colors.teal : Colors.grey),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: products
                    .where((product) => product['title']!
                        .toLowerCase()
                        .contains(searchText.toLowerCase()))
                    .map((product) => ProductCard(
                          title: product['title']!,
                          price: product['price']!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                        title: product['title']!,
                                        price: product['price']!,
                                      )),
                            );
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final VoidCallback onTap;

  const ProductCard(
      {super.key,
      required this.title,
      required this.price,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                'https://example.com/image.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                price,
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String title;
  final String price;

  const ProductDetailScreen(
      {super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://example.com/bracelet.jpg',
                width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Introducing the "$title" – a unique and captivating accessory...',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              children: [
                Text(price,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartScreen()));
                  },
                  child: const Text('Add to cart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Image.network('https://example.com/bracelet.jpg',
                  width: 50, height: 50),
              title: const Text('PalmaZen Woodland Bracelet'),
              subtitle: const Text('\$10'),
              trailing:
                  IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
            ),
            const Spacer(),
            const Row(
              children: [
                Text('Total:',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Spacer(),
                Text('\$10',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen()));
              },
              child: const Text('Go to Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ship & Pay'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last name'),
              ),
              DropdownButtonFormField<String>(
                items: ['Private person'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {},
                decoration: const InputDecoration(labelText: 'Shipping'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentMethodPage()),
                  );
                },
                child: const Text('Place order'),
              ),
            ],
          ),
        ));
  }
}

class PaymentMethodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          // Section 1: Transfer Virtual Account
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Transfer Virtual Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Bank BNI'),
            onTap: () {
              // Navigate to the Detail Payment Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPaymentPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Bank BCA'),
            onTap: () {
              // Navigate to the Detail Payment Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPaymentPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Bank Mandiri'),
            onTap: () {
              // Navigate to the Detail Payment Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPaymentPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Bank DKI'),
            onTap: () {
              // Navigate to the Detail Payment Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPaymentPage()),
              );
            },
          ),

          Divider(),

          // Section 2: Tunai Gerai (Cash Payments at Stores)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tunai Gerai',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.store), // Store icon for Alfamart
            title: Text('Alfamart'),
            onTap: () {
              // Navigate to the Detail Payment Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPaymentPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.store), // Store icon for Indomaret
            title: Text('Indomaret'),
            onTap: () {
              // Navigate to the Detail Payment Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailPaymentPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DetailPaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Payment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Chip(label: Text('e-wallet')),
                SizedBox(width: 10),
                Text('450008721300021'),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text('COPY'),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Payment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildPaymentDetail('Tree House', 'Rp.10.000.000'),
            buildPaymentDetail('Sugar Maple', 'Rp.10.000.000'),
            buildPaymentDetail('Northern Red Oak', 'Rp.50.000'),
            Divider(),
            buildPaymentDetail('Total', 'Rp.20.050.000'),
            SizedBox(height: 20),
            Text(
              'Mohon lakukan pembayaran sebelum tanggal',
              style: TextStyle(color: Colors.red),
            ),
            Text(
              'Jumat, 02 April 2021 23:59:59',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: Not Paid',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                TextButton(
                  onPressed: () {
                    // Cancel payment logic
                  },
                  child: Text(
                    'Cancel Payment',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildPaymentDetail(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
