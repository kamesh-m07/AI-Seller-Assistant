import 'package:ai_seller_assistant/screens/add_product.dart';
import 'package:ai_seller_assistant/screens/login.dart';
import 'package:ai_seller_assistant/screens/product_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({super.key});

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  int selectedIndex = 0;

  int totalProducts = 0;
  int totalAiListings = 0;
  double totalSales = 0;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();

    totalProducts = snapshot.docs.length;

    totalAiListings = snapshot.docs.where((doc) {
      return doc.data().containsKey('aiTitle');
    }).length;

    totalSales = 0;

    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('sellingPrice')) {
        totalSales += double.tryParse(doc['sellingPrice'].toString()) ?? 0;
      }
    }

    setState(() {});
  }

  Widget dashboardCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),

      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.amber),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'AI Seller Assistant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user?.email ?? 'No Email',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            dashboardCard('Products', totalProducts.toString()),

            dashboardCard('AI Listings', totalAiListings.toString()),

            dashboardCard('Sales', '₹${totalSales.toStringAsFixed(0)}'),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: selectedIndex,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddProductScreen()),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductList()),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Product"),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "AI Listing",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: "My Product",
          ),
        ],
      ),
    );
  }
}
