import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models/pokemon.dart';
import 'tela_login.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({super.key});

  @override
    State<TelaHome> createState() => TelaHomeState();
}

class TelaHomeState extends State<TelaHome> {
  late Future<List<Pokemon>> _pokemons;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _pokemons = dbHelper.getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: const Text("Pokédex"),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TelaLogin()));
          },
        ),
      ],
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Pokémons found"));
          } else {
            final pokemons = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final p = pokemons[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset(p.imagem, width: 80, height: 80, fit: BoxFit.cover),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.nome,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.tipo,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}