import 'package:flutter/material.dart';

class Produto {
  final String nome;
  final double preco;
  final String categoria;

  Produto({required this.nome, required this.preco, required this.categoria});
}

// Cada categoria tem o seu ícone
const Map<String, IconData> categorias = {
  'Eletrônicos': Icons.devices,
  'Roupas': Icons.checkroom,
  'Alimentos': Icons.lunch_dining,
  'Livros': Icons.menu_book,
  'Esportes': Icons.sports_soccer,
};

IconData iconeDaCategoria(String categoria) {
  return categorias[categoria] ?? Icons.inventory_2;
}
