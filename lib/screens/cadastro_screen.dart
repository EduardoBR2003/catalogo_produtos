import 'package:flutter/material.dart';

import '../models/produto.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final nomeController = TextEditingController();
  final precoController = TextEditingController();
  String? categoria;

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();
    super.dispose();
  }

  void salvar() {
    final nome = nomeController.text.trim();
    final preco = double.tryParse(precoController.text.replaceAll(',', '.'));

    if (nome.isEmpty || preco == null || categoria == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, preço e categoria')),
      );
      return;
    }

    Navigator.pop(
      context,
      Produto(nome: nome, preco: preco, categoria: categoria!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: precoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Preço',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: categoria,
              isExpanded: true,
              hint: const Text('Selecione a categoria'),
              items: categorias.keys.map((nome) {
                return DropdownMenuItem(
                  value: nome,
                  child: Row(
                    children: [
                      Icon(categorias[nome], color: Colors.teal),
                      const SizedBox(width: 8),
                      Text(nome),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  categoria = valor;
                });
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: salvar,
              icon: const Icon(Icons.check),
              label: const Text('Confirmar cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}
