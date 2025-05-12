import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'product_details.dart';
import 'login_page.dart'; // Assurez-vous que ce fichier existe

class Product {
  final int id;
  final String name;
  final double price;
  final String category;
  final String image;
  final double rating;
  final String description;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
    required this.description,
    this.isFavorite = false,
  });
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String selectedCategory = "Tous";
  String searchTerm = "";

  final List<String> categories = ["Tous", "Phones", "Audio", "Cameras", "Power", "Tablets"];

  final List<Product> products = [
    // Phones Category
    Product(
      id: 1,
      name: "iPhone 15 Pro",
      price: 999.99,
      category: "Phones",
      image: "https://images.unsplash.com/photo-1678911820864-e5a3eb4d8bf8?q=80&w=500&auto=format&fit=crop",
      rating: 4.8,
      description: "Le smartphone le plus avancé d'Apple avec une puce A17 Pro et un appareil photo professionnel.",
    ),
    Product(
      id: 2,
      name: "Samsung Galaxy S24",
      price: 899.99,
      category: "Phones",
      image: "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=500&auto=format&fit=crop",
      rating: 4.7,
      description: "Le flagship de Samsung avec l'intelligence artificielle Galaxy AI intégrée et un superbe écran Dynamic AMOLED 2X.",
    ),
    Product(
      id: 3,
      name: "Google Pixel 8",
      price: 799.99,
      category: "Phones",
      image: "https://images.unsplash.com/photo-1598327105666-5b89351aff97?q=80&w=500&auto=format&fit=crop",
      rating: 4.6,
      description: "Équipé du Google Tensor G3 et des fonctionnalités IA avancées pour des photos exceptionnelles.",
    ),
    Product(
      id: 4,
      name: "OnePlus 12",
      price: 749.99,
      category: "Phones",
      image: "https://images.unsplash.com/photo-1598965402089-897c5de12255?q=80&w=500&auto=format&fit=crop",
      rating: 4.5,
      description: "Performance ultra-rapide avec Snapdragon 8 Gen 3 et charge rapide 100W SUPERVOOC.",
    ),

    // Audio Category
    Product(
      id: 5,
      name: "AirPods Pro 2",
      price: 249.99,
      category: "Audio",
      image: "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?q=80&w=500&auto=format&fit=crop",
      rating: 4.8,
      description: "Réduction active du bruit premium et audio spatial personnalisé pour une immersion sonore totale.",
    ),
    Product(
      id: 6,
      name: "Sony WH-1000XM5",
      price: 399.99,
      category: "Audio",
      image: "https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?q=80&w=500&auto=format&fit=crop",
      rating: 4.9,
      description: "La référence en matière de casque à réduction de bruit avec 30 heures d'autonomie et son haute résolution.",
    ),
    Product(
      id: 7,
      name: "Galaxy Buds Pro",
      price: 199.99,
      category: "Audio",
      image: "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?q=80&w=500&auto=format&fit=crop",
      rating: 4.6,
      description: "Écouteurs sans fil avec réduction de bruit active et son immersif pour utilisateurs Samsung.",
    ),
    Product(
      id: 8,
      name: "Bose QuietComfort",
      price: 329.99,
      category: "Audio",
      image: "https://images.unsplash.com/photo-1546435770-a3e426bf472b?q=80&w=500&auto=format&fit=crop",
      rating: 4.7,
      description: "Confort légendaire et qualité sonore Bose avec une excellente annulation du bruit.",
    ),

    // Cameras Category
    Product(
      id: 9,
      name: "Sony A7 IV",
      price: 2499.99,
      category: "Cameras",
      image: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=500&auto=format&fit=crop",
      rating: 4.9,
      description: "Appareil photo hybride plein format 33MP avec des capacités photo et vidéo professionnelles.",
    ),
    Product(
      id: 10,
      name: "Canon R6 Mark II",
      price: 2299.99,
      category: "Cameras",
      image: "https://images.unsplash.com/photo-1502920917128-1aa500764cbd?q=80&w=500&auto=format&fit=crop",
      rating: 4.8,
      description: "Puissant capteur CMOS de 24,2 MP et système autofocus avancé pour des créations exceptionnelles.",
    ),
    Product(
      id: 11,
      name: "Fujifilm X-T5",
      price: 1699.99,
      category: "Cameras",
      image: "https://images.unsplash.com/photo-1581591524425-c7e0978865fc?q=80&w=500&auto=format&fit=crop",
      rating: 4.7,
      description: "Capteur X-Trans CMOS 5 HR de 40MP dans un boîtier compact avec des simulations de films emblématiques.",
    ),
    Product(
      id: 12,
      name: "Nikon Z6 II",
      price: 1999.99,
      category: "Cameras",
      image: "https://images.unsplash.com/photo-1586253634026-8cb574908d1e?q=80&w=500&auto=format&fit=crop",
      rating: 4.6,
      description: "Polyvalence exceptionnelle avec double processeur EXPEED 6 et capteur BSI de 24,5 MP.",
    ),

    // Power Category
    Product(
      id: 13,
      name: "100W GaN Charger",
      price: 79.99,
      category: "Power",
      image: "https://images.unsplash.com/photo-1583863788434-e62bd6bf5a41?q=80&w=500&auto=format&fit=crop",
      rating: 4.5,
      description: "Chargeur compact et puissant avec technologie GaN pour recharger tous vos appareils simultanément.",
    ),
    Product(
      id: 14,
      name: "20000mAh Power Bank",
      price: 49.99,
      category: "Power",
      image: "https://images.unsplash.com/photo-1618410320928-25228d811631?q=80&w=500&auto=format&fit=crop",
      rating: 4.6,
      description: "Batterie externe haute capacité avec charge rapide pour plusieurs recharges complètes de votre smartphone.",
    ),
    Product(
      id: 15,
      name: "Wireless Charging Pad",
      price: 39.99,
      category: "Power",
      image: "https://images.unsplash.com/photo-1662560884455-e89e8dcde945?q=80&w=500&auto=format&fit=crop",
      rating: 4.4,
      description: "Chargeur sans fil élégant compatible Qi avec charge rapide jusqu'à 15W pour une expérience sans câble.",
    ),
    Product(
      id: 16,
      name: "MagSafe Battery Pack",
      price: 99.99,
      category: "Power",
      image: "https://images.unsplash.com/photo-1659941451212-4a2cb3b3e09b?q=80&w=500&auto=format&fit=crop",
      rating: 4.3,
      description: "Batterie magnétique qui se fixe parfaitement à votre iPhone pour une charge sans fil pratique en déplacement.",
    ),

    // Tablets Category
    Product(
      id: 17,
      name: "iPad Pro 12.9",
      price: 1099.99,
      category: "Tablets",
      image: "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=500&auto=format&fit=crop",
      rating: 4.9,
      description: "Tablette puissante avec puce M2, écran Liquid Retina XDR et compatibilité Apple Pencil 2.",
    ),
    Product(
      id: 18,
      name: "Galaxy Tab S9 Ultra",
      price: 999.99,
      category: "Tablets",
      image: "https://images.unsplash.com/photo-1561154464-82e9adf32764?q=80&w=500&auto=format&fit=crop",
      rating: 4.7,
      description: "Immense écran AMOLED de 14,6 pouces avec S Pen inclus et performances exceptionnelles.",
    ),
    Product(
      id: 19,
      name: "Surface Pro 9",
      price: 1199.99,
      category: "Tablets",
      image: "https://images.unsplash.com/photo-1593642634367-d91a135587b5?q=80&w=500&auto=format&fit=crop",
      rating: 4.6,
      description: "La polyvalence d'un PC et d'une tablette avec Windows 11 et processeurs Intel Core de 12e génération.",
    ),
    Product(
      id: 20,
      name: "Xiaomi Pad 6 Pro",
      price: 399.99,
      category: "Tablets",
      image: "https://images.unsplash.com/photo-1589739900243-4b52cd9b104e?q=80&w=500&auto=format&fit=crop",
      rating: 4.5,
      description: "Rapport qualité-prix exceptionnel avec écran 144Hz et processeur Snapdragon 8+ Gen 1.",
    ),
  ];

  final List<Product> cartItems = [];

  List<Product> get filteredProducts {
    return products.where((product) {
      return (selectedCategory == "Tous" || product.category == selectedCategory) &&
          product.name.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }

  void toggleFavorite(int productId) {
    setState(() {
      final productIndex = products.indexWhere((p) => p.id == productId);
      if (productIndex != -1) {
        products[productIndex].isFavorite = !products[productIndex].isFavorite;
      }
    });
  }

  void addToCart(Product product) {
    setState(() {
      cartItems.add(product);
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      cartItems.remove(product);
    });
  }

  // Function to convert price to TND (assuming conversion rate of 3.3 TND per Euro)
  String formatPriceInTND(double price) {
    // Convert to TND (example conversion rate: 1 EUR = 3.3 TND)
    double tndPrice = price * 3.3;
    return '${tndPrice.toStringAsFixed(2)} TND';
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la hauteur de la zone de sécurité inférieure pour éviter le problème de pixels
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final mediaQuery = MediaQuery.of(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9FAFB), Color(0xFFF3F4F6)],
          ),
        ),
        child: SafeArea(
          bottom: false, // Important: désactiver SafeArea en bas pour gérer manuellement
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              foregroundColor: selectedCategory == category
                                  ? Colors.white
                                  : Colors.grey[600],
                              elevation: selectedCategory == category ? 4 : 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: selectedCategory == category
                                  ? Colors.transparent
                                  : Colors.white,
                            ).copyWith(
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: Container(
                              decoration: selectedCategory == category
                                  ? const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF3B82F6),
                                          Color(0xFF8B5CF6),
                                          Color(0xFFEC4899),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                    )
                                  : null,
                              padding: selectedCategory == category
                                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                                  : EdgeInsets.zero,
                              child: Text(category),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: GridView.builder(
                    // Correction définitive du problème de pixels en utilisant MediaQuery
                    padding: EdgeInsets.only(
                      bottom: 80 + bottomPadding, // Ajout de la hauteur de la zone de sécurité
                    ),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: mediaQuery.size.width > 600 ? 0.9 : 0.8, // Responsive
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _buildProductCard(product);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(cartItems: cartItems),
            ),
          );
        },
        backgroundColor: const Color(0xFFF35C7A),
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () async {
        // Navigation vers la page de détails du produit
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: product,
              addToCart: addToCart,
            ),
          ),
          
        );

        // Gestion du retour de la page détails (pour la gestion des favoris)
        if (result != null && result is Map<String, dynamic>) {
          if (result['action'] == 'toggleFavorite') {
            toggleFavorite(result['id']);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit avec Image.network standard
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      // Gestion améliorée du chargement des images
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFF35C7A)),
                            ),
                          ),
                        );
                      },
                      // Gestion améliorée des erreurs d'images
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () => toggleFavorite(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          product.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: product.isFavorite ? Colors.red : Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Informations du produit avec padding réduit
            Padding(
              padding: const EdgeInsets.all(6.0), // Réduit encore plus
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom du produit
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Réduit encore plus
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2), // Réduit encore plus

                  // Prix
                  Text(
                    formatPriceInTND(product.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Réduit encore plus
                    ),
                  ),

                  const SizedBox(height: 2), // Réduit encore plus

                  // Bouton avec taille réduite
                  SizedBox(
                    width: double.infinity,
                    height: 26, // Hauteur réduite encore plus
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(product);
                        // Afficher un snackbar pour confirmer l'ajout
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} ajouté au panier'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: const Color(0xFF1E293B),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        textStyle: const TextStyle(fontSize: 10),
                        backgroundColor: const Color(0xFFF35C7A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Ajouter au panier'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}