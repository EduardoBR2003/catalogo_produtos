# Catálogo de Produtos

Atividade 6 – Formulário e validação.

Aplicativo Flutter que mostra uma lista de produtos em Cards, com o ícone definido pela categoria. Tocar em um produto mostra um SnackBar avisando que ele foi adicionado ao carrinho.

O botão **Novo produto** abre a tela **Cadastrar Produto**, feita com o widget `Form`. Ao confirmar, cada campo é validado:

| Campo | Regras |
|-------|--------|
| Nome | obrigatório; de 3 a 40 caracteres; não pode ter só números; não pode repetir um nome que já está no catálogo |
| Preço | obrigatório; somente números com até 2 casas decimais (aceita vírgula ou ponto); maior que zero; no máximo R$ 99.999,99 |
| Categoria | obrigatória, escolhida em um `DropdownButton` |

Se algum campo não passar, a mensagem de erro aparece embaixo dele e um SnackBar avisa que há campos inválidos. Com tudo certo, o app volta para a tela principal e o produto é adicionado ao final da lista, mantendo os que já existiam.

## Como executar

```bash
flutter pub get
flutter run
```
