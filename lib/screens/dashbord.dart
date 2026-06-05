import 'package:ai_seller_assistant/screens/add_product.dart';
import 'package:ai_seller_assistant/screens/product_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({super.key});

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),

      endDrawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('User'),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Text(data),
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [Text('Products'), Text('156')]),
            ),
          ),
          const SizedBox(height: 25),
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Column(children: [Text('Ai Listing'), Text('34')]),
            ),
          ),
          const SizedBox(height: 25),
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [Text('Sales'), Text('₹25,000')]),
            ),
          ),
        ],
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
              MaterialPageRoute(builder: (context) => AddProductScreen()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductList()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Product "),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: "Ai Listing",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: "My Product",
          ),
        ],
      ),
    );
  }
}
