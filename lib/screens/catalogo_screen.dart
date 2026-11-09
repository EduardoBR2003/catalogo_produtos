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

  String formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void adicionarAoCarrinho(Produto produto) {
    setState(() {
      itensNoCarrinho++;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} foi adicionado ao carrinho'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> abrirCadastro() async {
    final novo = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroScreen(
          nomesExistentes: produtos.map((p) => p.nome).toList(),
        ),
      ),
    );

    if (novo == null || !mounted) return;

    setState(() {
      produtos.add(novo);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${novo.nome} cadastrado no catálogo')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Badge(
              label: Text('$itensNoCarrinho'),
              isLabelVisible: itensNoCarrinho > 0,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              '${produtos.length} produtos  •  toque em um item para adicionar ao carrinho',
              style: TextStyle(color: Colors.indigo.shade700),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      iconeDaCategoria(produto.categoria),
                      color: Colors.indigo,
                      size: 32,
                    ),
                    title: Text(produto.nome),
                    subtitle: Text(produto.categoria),
                    trailing: Text(
                      formatarPreco(produto.preco),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () => adicionarAoCarrinho(produto),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirCadastro,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo produto'),
      ),
    );
  }
}
