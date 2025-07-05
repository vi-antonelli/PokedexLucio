import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models/pokemon.dart';

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
      appBar: AppBar(title: const Text("Pokémons")),
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
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final p = pokemons[index];
                return ListTile(
                                    leading: Image.asset(p.imagem, width: 50),
                  title: Text(p.nome),
                  subtitle: Text(p.tipo),
                );
              },
            );
          }
        },
      ),
    );
  }
}