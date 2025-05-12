import 'package:flutter/material.dart';
import 'login_page.dart'; // Assurez-vous que ce fichier existe
import 'cart_page.dart'; // Assurez-vous que ce fichier existe

class Navbar extends StatefulWidget {
  final List<dynamic> cartItems;
  
  const Navbar({
    super.key, 
    this.cartItems = const [], // Valeur par défaut vide
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      color: const Color(0xFF1E293B), // slate-800
      child: Column(
        children: [
          // First row with logo and icons
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : (screenWidth > 1280 ? 96 : 32),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo and title
                GestureDetector(
                  onTap: () {
                    // Navigate to home
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        color: const Color(0xFFF35C7A),
                        size: isMobile ? 24 : 32,
                      ),
                      SizedBox(width: isMobile ? 8 : 12),
                      const Text(
                        'T&O',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Icons section
                Row(
                  children: [
                    // Profile icon with "Se connecter" text - Navigation vers login/signup
                    GestureDetector(
                      onTap: () {
                        // Navigation vers la page login
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: isMobile ? 4 : 8),
                          const Text(
                            'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(width: isMobile ? 16 : 24),
                    
                    // Shop icon - Navigation vers le panier
                    GestureDetector(
                      onTap: () {
                        // Navigation vers la page panier
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(cartItems: widget.cartItems),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          if (widget.cartItems.isNotEmpty)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF35C7A),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.cartItems.length}', // Nombre dynamique d'articles
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Small gap between icons and search bar
          const SizedBox(height: 8),
          
          // Search bar slightly below
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : (screenWidth > 1280 ? 96 : 32),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Rechercher des produits...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (value) {
                  // Vous pouvez implémenter la recherche ici
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}