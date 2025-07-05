import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'tela_home.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final user = await dbHelper.getUser(_emailController.text, _passController.text);
            if (user != null) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TelaHome()));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login inválido')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/pokeball_background.png', // You'll need to add a pokeball_background.png to your assets/images folder
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/pokemon_logo.png', // You'll need to add a pokemon_logo.png to your assets/images folder
                      height: 150,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.person, color: Colors.black54),
                      ),
                      validator: (value) => value!.contains('@') ? null : "Email inválido",
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passController,
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        prefixIcon: Icon(Icons.lock, color: Colors.black54),
                      ),
                      obscureText: true,
                      validator: (value) => value!.isEmpty ? "Senha obrigatória" : null,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text("Entrar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
