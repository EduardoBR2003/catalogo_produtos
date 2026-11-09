import 'package:flutter/material.dart';

import '../models/produto.dart';

class CadastroScreen extends StatefulWidget {
  // nomes que já estão no catálogo, para não cadastrar repetido
  final List<String> nomesExistentes;

  const CadastroScreen({super.key, required this.nomesExistentes});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final precoController = TextEditingController();
  String? categoria;

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();
    super.dispose();
  }

  // Regras do nome:
  // obrigatório, entre 3 e 40 letras, não pode ser só número e não pode repetir
  String? validarNome(String? valor) {
    final nome = (valor ?? '').trim();
    if (nome.isEmpty) {
      return 'Informe o nome do produto';
    }
    if (nome.length < 3) {
      return 'O nome precisa ter pelo menos 3 caracteres';
    }
    if (nome.length > 40) {
      return 'O nome pode ter no máximo 40 caracteres';
    }
    if (RegExp(r'^[0-9\s]+$').hasMatch(nome)) {
      return 'O nome não pode ter apenas números';
    }
    final repetido = widget.nomesExistentes
        .any((n) => n.toLowerCase() == nome.toLowerCase());
    if (repetido) {
      return 'Já existe um produto com esse nome';
    }
    return null;
  }

  // Regras do preço:
  // obrigatório, número válido, maior que zero, até 2 casas decimais e no máximo 99.999,99
  String? validarPreco(String? valor) {
    final texto = (valor ?? '').trim().replaceAll(',', '.');
    if (texto.isEmpty) {
      return 'Informe o preço';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(texto)) {
      return 'Use somente números, com até 2 casas decimais (ex: 12,50)';
    }
    final preco = double.parse(texto);
    if (preco <= 0) {
      return 'O preço deve ser maior que zero';
    }
    if (preco > 99999.99) {
      return 'O preço máximo é R\$ 99.999,99';
    }
    return null;
  }

  // Regra da categoria: precisa escolher uma
  String? validarCategoria(String? valor) {
    if (valor == null) {
      return 'Escolha uma categoria';
    }
    return null;
  }

  void confirmar() {
    final ok = _formKey.currentState!.validate();

    if (!ok) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Existem campos inválidos. Confira as mensagens em vermelho.'),
        ),
      );
      return;
    }

    final preco = double.parse(precoController.text.trim().replaceAll(',', '.'));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.pop(
      context,
      Produto(
        nome: nomeController.text.trim(),
        preco: preco,
        categoria: categoria!,
      ),
    );
  }

  void limpar() {
    _formKey.currentState!.reset();
    nomeController.clear();
    precoController.clear();
    setState(() {
      categoria = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: nomeController,
              maxLength: 40,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                prefixIcon: Icon(Icons.label_outline),
                border: OutlineInputBorder(),
              ),
              validator: validarNome,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: precoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Preço',
                prefixText: 'R\$ ',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              validator: validarPreco,
            ),
            const SizedBox(height: 16),
            // FormField em volta do DropdownButton para ele também ser validado pelo Form
            FormField<String>(
              validator: (_) => validarCategoria(categoria),
              builder: (campo) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: const OutlineInputBorder(),
                    errorText: campo.errorText,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: categoria,
                      isExpanded: true,
                      isDense: true,
                      hint: const Text('Selecione'),
                      items: categorias.keys.map((nome) {
                        return DropdownMenuItem(
                          value: nome,
                          child: Row(
                            children: [
                              Icon(categorias[nome], color: Colors.indigo),
                              const SizedBox(width: 10),
                              Text(nome),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        setState(() {
                          categoria = valor;
                        });
                        campo.didChange(valor);
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: limpar,
                    child: const Text('Limpar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: confirmar,
                    icon: const Icon(Icons.save),
                    label: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
