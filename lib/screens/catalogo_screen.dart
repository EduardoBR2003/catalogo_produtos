import 'package:flutter/material.dart';

import '../models/produto.dart';
import 'cadastro_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final List<Produto> produtos = [
    Produto(nome: 'Fone de ouvido', preco: 89.90, categoria: 'Eletrônicos'),
    Produto(nome: 'Camiseta básica', preco: 39.90, categoria: 'Roupas'),
    Produto(nome: 'Café 500g', preco: 18.50, categoria: 'Alimentos'),
    Produto(nome: 'Dom Casmurro', preco: 29.00, categoria: 'Livros'),
    Produto(nome: 'Bola de futebol', preco: 75.00, categoria: 'Esportes'),
  ];

  int itensNoCarrinho = 0;

  void comprar(Produto produto) {
    setState(() {
      itensNoCarrinho++;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${produto.nome} foi adicionado ao carrinho')),
    );
  }

  Future<void> abrirCadastro() async {
    final novo = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(builder: (context) => const CadastroScreen()),
    );

    if (novo != null) {
      setState(() {
        produtos.add(novo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Badge(
              label: Text('$itensNoCarrinho'),
              isLabelVisible: itensNoCarrinho > 0,
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade50,
                child: Icon(iconeDaCategoria(produto.categoria),
                    color: Colors.teal),
              ),
              title: Text(produto.nome),
              subtitle: Text(
                'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}'
                '  •  ${produto.categoria}',
              ),
              trailing: ElevatedButton(
                onPressed: () => comprar(produto),
                child: const Text('Comprar'),
              ),
              onTap: () => comprar(produto),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCadastro,
        tooltip: 'Cadastrar produto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
