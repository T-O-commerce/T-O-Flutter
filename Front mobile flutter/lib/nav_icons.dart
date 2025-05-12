import 'package:flutter/material.dart';
import 'cart_model.dart';

class NavIcons extends StatefulWidget {
  const NavIcons({super.key});

  @override
  State<NavIcons> createState() => _NavIconsState();
}

class _NavIconsState extends State<NavIcons> {
  bool _isProfileOpen = false;
  bool _isCartOpen = false;

  void _handleProfile() {
    setState(() {
      _isProfileOpen = !_isProfileOpen;
      if (_isProfileOpen) _isCartOpen = false;
    });
  }

  void _handleCartClick() {
    setState(() {
      _isCartOpen = !_isCartOpen;
      if (_isCartOpen) _isProfileOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile icon with dropdown
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 24,
              ),
              onPressed: _handleProfile,
            ),
            if (_isProfileOpen)
              Positioned(
                top: 48,
                right: 0,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigate to profile
                          setState(() {
                            _isProfileOpen = false;
                          });
                        },
                        child: const Text('Profile'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Logout
                          setState(() {
                            _isProfileOpen = false;
                          });
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        
        // Notification icon
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            // Handle notification
          },
        ),
        
        // Cart icon with badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 24,
              ),
              onPressed: _handleCartClick,
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFF35C7A),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            if (_isCartOpen)
              const Positioned(
                top: 48,
                right: 0,
                child: CartModal(),
              ),
          ],
        ),
      ],
    );
  }
}
