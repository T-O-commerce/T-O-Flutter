import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

// Constante pour l'URL de base de l'API
const String baseUrl = 'http://192.168.1.31:3000/api/auth'; // Pour l'émulateur Android
// const String baseUrl = 'http://localhost:5000/api'; // Pour le web ou iOS

// Modèle d'utilisateur pour stocker les données
class User {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? profileImage;
  final String token;
  final String role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.address,
    this.profileImage,
    required this.token,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['Full_Name'],
      email: json['Email'],
      phoneNumber: json['Phone_Number'],
      address: json['Adress'],
      profileImage: json['image'],
      token: json['token'],
      role: json['role'] ?? 'client',
    );
  }
}

// Service d'authentification
class AuthService {
  // Méthode pour l'enregistrement
  static Future<Map<String, dynamic>> register(
      String fullName, String email, String password, String phoneNumber, String address, File? image) async {
    try {
      print('Démarrage de l\'inscription...');
      print('URL de l\'API: $baseUrl/register');
      print('Données envoyées: $fullName, $email, $phoneNumber, $address');
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/register'),
      );

      // Correspondance avec le modèle MongoDB
      request.fields['Full_Name'] = fullName;
      request.fields['Email'] = email;
      request.fields['Password'] = password;
      request.fields['Phone_Number'] = phoneNumber;
      request.fields['Adress'] = address;
      // Le champ role prendra sa valeur par défaut "client"

      // Ajouter l'image si elle existe
      if (image != null) {
        print('Ajout de l\'image: ${image.path}');
        try {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              image.path,
              filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          );
          print('Image ajoutée avec succès');
        } catch (imageError) {
          print('Erreur lors de l\'ajout de l\'image: $imageError');
        }
      } else {
        print('Aucune image sélectionnée');
      }

      print('Envoi de la requête d\'inscription...');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print('Code de réponse: ${response.statusCode}');
      print('Réponse du serveur: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Succès - accepter 200 ou 201
        final data = json.decode(response.body);
        print('Inscription réussie');
        return {
          'success': true,
          'user': User.fromJson(data['user']),
          'message': 'Inscription réussie! Vous pouvez maintenant vous connecter.',
        };
      } else {
        // Erreur
        print('Échec de l\'inscription');
        Map<String, dynamic> error = {};
        try {
          error = json.decode(response.body);
        } catch (e) {
          print('Erreur de décodage JSON: $e');
        }
        return {
          'success': false,
          'message': error['message'] ?? 'Erreur lors de l\'inscription. Veuillez réessayer.',
        };
      }
    } catch (e) {
      print('Exception lors de l\'inscription: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur: $e',
      };
    }
  }

  // Méthode pour la connexion
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Email': email,  // Correspondance avec le modèle MongoDB
          'Password': password,  // Correspondance avec le modèle MongoDB
        }),
      );

      if (response.statusCode == 200) {
        // Succès
        final data = json.decode(response.body);
        
        // Sauvegarder le token dans les préférences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('userId', data['user']['_id']);
        prefs.setString('userRole', data['user']['role']); // Sauvegarde du rôle
        
        return {
          'success': true,
          'user': User.fromJson(data['user']),
          'message': 'Connexion réussie',
        };
      } else {
        // Erreur
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Identifiants incorrects',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  // Méthode pour valider le token (vérifier si l'utilisateur est connecté)
  static Future<bool> validateToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        return false;
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/auth/validate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // Méthode pour déconnexion
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }
}

class LoginPage extends StatefulWidget {
  // Ajouter un callback pour la connexion réussie
  final VoidCallback? onLoginSuccess;

  const LoginPage({
    super.key,
    this.onLoginSuccess,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Pour basculer entre connexion et inscription
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de texte
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _obscurePassword = true; // Pour afficher/masquer le mot de passe
  bool _isLoading = false; // Pour afficher un indicateur de chargement
  String _errorMessage = ''; // Pour afficher les messages d'erreur
  
  // Sélection d'image pour l'inscription
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
      // Réinitialiser les erreurs lors du changement de mode
      _errorMessage = '';
    });
  }

  // Méthode pour sélectionner une image
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75, // Réduire la qualité pour optimiser la taille
      );
      
      if (image != null) {
        print('Image sélectionnée: ${image.path}');
        final File imageFile = File(image.path);
        
        // Vérification de l'existence et de la taille du fichier
        if (await imageFile.exists()) {
          final size = await imageFile.length();
          print('Taille de l\'image: ${(size / 1024).toStringAsFixed(2)} KB');
          
          setState(() {
            _selectedImage = imageFile;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image sélectionnée avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('Le fichier image n\'existe pas');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: Le fichier image n\'existe pas'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        print('Aucune image sélectionnée');
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection de l\'image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Méthode pour la soumission du formulaire
  Future<void> _submitForm() async {
    // Valider le formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      if (isLogin) {
        // Connexion
        final result = await AuthService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (result['success']) {
          // Connexion réussie
          // Afficher un message de succès
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connexion réussie!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Récupérer le rôle pour potentiellement rediriger selon le type d'utilisateur
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final userRole = prefs.getString('userRole') ?? 'client';
          
          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!();
          } else {
            // Rediriger vers la page appropriée selon le rôle
            try {
              if (userRole == 'admin') {
                Navigator.pushReplacementNamed(context, '/admin');
              } else {
                Navigator.pushReplacementNamed(context, '/home');  // Changé de '/' à '/home'
              }
            } catch (navError) {
              print('Erreur de navigation: $navError');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Page non trouvée. Vérifiez vos routes dans main.dart'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        } else {
          // Afficher l'erreur
          setState(() {
            _errorMessage = result['message'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Échec de connexion: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Inscription
        print('Début du processus d\'inscription');
        
        // Vérification des champs avant envoi
        print('Nom: ${_nameController.text.trim()}');
        print('Email: ${_emailController.text.trim()}');
        print('Téléphone: ${_phoneController.text.trim()}');
        print('Adresse: ${_addressController.text.trim()}');
        print('Image sélectionnée: ${_selectedImage != null ? 'Oui' : 'Non'}');
        
        final result = await AuthService.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
          _phoneController.text.trim(),
          _addressController.text.trim(),
          _selectedImage,
        );

        print('Résultat de l\'inscription: ${result['success']}');

        if (result['success']) {
          // Inscription réussie, passer en mode connexion
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
            ),
          );
          setState(() {
            isLogin = true;
            // Réinitialiser les champs
            _nameController.clear();
            _emailController.clear();
            _passwordController.clear();
            _phoneController.clear();
            _addressController.clear();
            _selectedImage = null;
          });
        } else {
          // Afficher l'erreur
          setState(() {
            _errorMessage = result['message'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Échec d\'inscription: ${result['message']}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      print('Exception dans _submitForm: $e');
      setState(() {
        _errorMessage = 'Une erreur est survenue: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : screenWidth * 0.2,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo et titre
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          color: const Color(0xFFF35C7A),
                          size: isMobile ? 32 : 40,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'T&O',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: screenHeight * 0.05),
                    
                    // Titre de la page
                    Text(
                      isLogin ? 'Connexion' : 'Créer un compte',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Sous-titre
                    Text(
                      isLogin 
                          ? 'Connectez-vous pour accéder à votre compte'
                          : 'Inscrivez-vous pour commencer votre expérience',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.04),
                    
                    // Message d'erreur
                    if (_errorMessage.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Formulaire
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Photo de profil (uniquement pour l'inscription)
                            if (!isLogin) ...[
                              Center(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: _pickImage,
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey[200],
                                        backgroundImage: _selectedImage != null
                                            ? FileImage(_selectedImage!)
                                            : null,
                                        child: _selectedImage == null
                                            ? const Icon(
                                                Icons.add_a_photo,
                                                size: 30,
                                                color: Colors.grey,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: _pickImage,
                                      child: const Text(
                                        'Ajouter une photo de profil',
                                        style: TextStyle(
                                          color: Color(0xFFF35C7A),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ],
                            
                            // Champ Nom (uniquement pour l'inscription)
                            if (!isLogin) ...[
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Nom complet',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (!isLogin && (value == null || value.isEmpty)) {
                                    return 'Veuillez entrer votre nom';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              
                              // Champ Téléphone
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Numéro de téléphone',
                                  prefixIcon: const Icon(Icons.phone_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre numéro de téléphone';
                                  }
                                  // Vous pouvez ajouter une validation plus stricte pour le format du téléphone
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              
                              // Champ Adresse
                              TextFormField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                  labelText: 'Adresse',
                                  prefixIcon: const Icon(Icons.home_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre adresse';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            
                            // Champ Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Veuillez entrer un email valide';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Champ Mot de passe
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword 
                                        ? Icons.visibility_outlined 
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre mot de passe';
                                }
                                if (!isLogin && value.length < 6) {
                                  return 'Le mot de passe doit contenir au moins 6 caractères';
                                }
                                return null;
                              },
                            ),
                            
                            // Mot de passe oublié (uniquement pour la connexion)
                            if (isLogin) ...[
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Naviguer vers la page de récupération de mot de passe
                                    // À implémenter
                                  },
                                  child: const Text(
                                    'Mot de passe oublié?',
                                    style: TextStyle(
                                      color: Color(0xFF1E293B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            
                            const SizedBox(height: 24),
                            
                            // Bouton de soumission
                            ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFF35C7A),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      isLogin ? 'Se connecter' : 'S\'inscrire',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Séparateur
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[300],
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'ou',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[300],
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Boutons de connexion sociale
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _socialButton(
                                  icon: Icons.g_mobiledata,
                                  color: Colors.red,
                                  onPressed: () {
                                    // Connexion avec Google
                                    // À implémenter
                                  },
                                ),
                                const SizedBox(width: 16),
                                _socialButton(
                                  icon: Icons.facebook,
                                  color: Colors.blue,
                                  onPressed: () {
                                    // Connexion avec Facebook
                                    // À implémenter
                                  },
                                ),
                                const SizedBox(width: 16),
                                _socialButton(
                                  icon: Icons.apple,
                                  color: Colors.black,
                                  onPressed: () {
                                    // Connexion avec Apple
                                    // À implémenter
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Lien pour basculer entre connexion et inscription
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        children: [
                          TextSpan(
                            text: isLogin 
                                ? 'Vous n\'avez pas de compte? ' 
                                : 'Vous avez déjà un compte? ',
                          ),
                          TextSpan(
                            text: isLogin ? 'S\'inscrire' : 'Se connecter',
                            style: const TextStyle(
                              color: Color(0xFFF35C7A),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _toggleAuthMode,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
      ),
    );
  }
}