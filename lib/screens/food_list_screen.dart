import 'package:alimentracker/models/food_model.dart';
import 'package:alimentracker/screens/food_info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FoodListScreen extends StatefulWidget {
  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _recipeSearchController = TextEditingController();
  String _searchQuery = '';
  String _recipeSearchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _recipeSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Comidas'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Lista de Alimentos'),
              Tab(text: 'Minhas Receitas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Pesquisar comida',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                Expanded(child: _buildFoodList()),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _recipeSearchController,
                    decoration: InputDecoration(
                      labelText: 'Pesquisar receitas',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _recipeSearchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                Expanded(child: _buildRecipeList()),
              ],
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildFoodList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('foods').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar os dados.'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Nenhuma comida encontrada.'));
        }

        final foodDocs = snapshot.data!.docs.where((doc) {
          final foodData = doc.data() as Map<String, dynamic>;
          final nome = (foodData['Nome'] ?? '').toString().toLowerCase();
          return nome.contains(_searchQuery);
        }).toList();

        if (foodDocs.isEmpty) {
          return Center(child: Text('Nenhuma comida corresponde à pesquisa.'));
        }

        return ListView.builder(
          itemCount: foodDocs.length,
          itemBuilder: (context, index) {
            final foodData = foodDocs[index].data() as Map<String, dynamic>;

            final nome = foodData['Nome'] ?? 'Nome não disponível';
            final calorias = _safeParseDouble(foodData['Calorias']);
            final proteinas = _safeParseDouble(foodData['Proteína']);
            final carboidratos = _safeParseDouble(foodData['Carboidratos']);
            final lipideos = _safeParseDouble(foodData['Lipídeos']);

            FoodModel foodModel = FoodModel(
              name: nome,
              kcal: calorias,
              protein: proteinas,
              carbohydrate: carboidratos,
              fat: lipideos,
            );

            return ListTile(
              title: Text(nome),
              subtitle: Text(
                'Calorias: ${calorias.toStringAsFixed(2)}\n'
                    'Proteínas: ${proteinas.toStringAsFixed(2)} g\n'
                    'Carboidratos: ${carboidratos.toStringAsFixed(2)} g\n'
                    'Lipídeos: ${lipideos.toStringAsFixed(2)} g',
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FoodInfoScreen(
                      foodModel: foodModel,
                      isAdd: true,
                      mealId: "",
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRecipeList() {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('recipes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar receitas.'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Nenhuma receita encontrada.'));
        }

        final recipeDocs = snapshot.data!.docs.where((doc) {
          final recipeData = doc.data() as Map<String, dynamic>;
          final nome = (recipeData['Nome'] ?? '').toString().toLowerCase();
          return nome.contains(_recipeSearchQuery);
        }).toList();

        if (recipeDocs.isEmpty) {
          return Center(child: Text('Nenhuma receita corresponde à pesquisa.'));
        }

        return ListView.builder(
          itemCount: recipeDocs.length,
          itemBuilder: (context, index) {
            final recipeData = recipeDocs[index].data() as Map<String, dynamic>;

            final mealDoc = snapshot.data!.docs[index];
            final nome = recipeData['Nome'] ?? 'Nome não disponível';
            final calorias = _safeParseDouble(recipeData['Calorias']);
            final proteinas = _safeParseDouble(recipeData['Proteínas']);
            final carboidratos = _safeParseDouble(recipeData['Carboidratos']);
            final lipideos = _safeParseDouble(recipeData['Gorduras']);

            FoodModel foodModel = FoodModel(
              name: nome,
              kcal: calorias,
              protein: proteinas,
              carbohydrate: carboidratos,
              fat: lipideos,
            );

            return Slidable(
              endActionPane: ActionPane(
                motion: StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      _editRecipe(context, mealDoc);
                    },
                    icon: Icons.edit,
                    backgroundColor: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  SlidableAction(
                    onPressed: (_) {
                      _deleteRecipe(context, mealDoc);
                    },
                    icon: Icons.delete,
                    backgroundColor: Colors.red.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(nome),
                subtitle: Text(
                  'Calorias: ${calorias.toStringAsFixed(2)}\n'
                      'Proteínas: ${proteinas.toStringAsFixed(2)} g\n'
                      'Carboidratos: ${carboidratos.toStringAsFixed(2)} g\n'
                      'Lipídeos: ${lipideos.toStringAsFixed(2)} g',
                ),
                isThreeLine: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FoodInfoScreen(
                        foodModel: foodModel,
                        isAdd: true,
                        mealId: "",
                      ),
                    ),
                  );
                },
              ),
            );


          },
        );
      },
    );
  }

  void _editRecipe(BuildContext context, DocumentSnapshot mealDoc) async {
    final recipeData = mealDoc.data() as Map<String, dynamic>;

    final _nomeController = TextEditingController(text: recipeData['Nome']);
    final _porcaoController = TextEditingController(text: recipeData['Porção'].toString());
    final _carboidratosController = TextEditingController(text: recipeData['Carboidratos'].toString());
    final _proteinasController = TextEditingController(text: recipeData['Proteínas'].toString());
    final _gordurasController = TextEditingController(text: recipeData['Gorduras'].toString());
    final _caloriasController = TextEditingController(text: recipeData['Calorias'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Receita'),
          content: Form(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),
                  TextFormField(
                    controller: _porcaoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Porção (g)'),
                  ),
                  TextFormField(
                    controller: _carboidratosController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Carboidratos (g)'),
                  ),
                  TextFormField(
                    controller: _proteinasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Proteínas (g)'),
                  ),
                  TextFormField(
                    controller: _gordurasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Gorduras (g)'),
                  ),
                  TextFormField(
                    controller: _caloriasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Calorias (g)'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () {
                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('recipes').doc(mealDoc.id).update({
                  'Nome': _nomeController.text,
                  'Porção': double.parse(_porcaoController.text),
                  'Carboidratos': double.parse(_carboidratosController.text),
                  'Proteínas': double.parse(_proteinasController.text),
                  'Gorduras': double.parse(_gordurasController.text),
                  'Calorias': double.parse(_caloriasController.text),
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteRecipe(BuildContext context, DocumentSnapshot mealDoc) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Receita'),
          content: Text('Tem certeza de que deseja excluir esta receita?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Excluir'),
              onPressed: () {
                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('recipes').doc(mealDoc.id).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _showAddRecipeDialog(context, false);
      },
      child: Icon(Icons.add),
      tooltip: 'Adicionar Receita',
    );
  }

  double _safeParseDouble(dynamic value) {
    try {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      return 0.0;
    }
  }


  void _showAddRecipeDialog(BuildContext context, bool isEdit) {


    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nomeController = TextEditingController();
    final TextEditingController _porcaoController = TextEditingController();
    final TextEditingController _carboidratosController = TextEditingController();
    final TextEditingController _proteinasController = TextEditingController();
    final TextEditingController _gordurasController = TextEditingController();
    final TextEditingController _caloriasController = TextEditingController();



    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Receita'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _porcaoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Porção (g)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a porção';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _carboidratosController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Carboidratos (g)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira os carboidratos';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _proteinasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Proteínas (g)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira as proteínas';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _gordurasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Gorduras (g)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira as gorduras';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _caloriasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Calorias (g)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira as calorias';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addRecipe(
                    nome: _nomeController.text,
                    porcao: double.parse(_porcaoController.text),
                    carboidratos: double.parse(_carboidratosController.text),
                    proteinas: double.parse(_proteinasController.text),
                    gorduras: double.parse(_gordurasController.text),
                    calorias: double.parse(_caloriasController.text),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addRecipe({
    required String nome,
    required double porcao,
    required double carboidratos,
    required double proteinas,
    required double gorduras,
    required double calorias,
  }) {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('recipes').add({
      'Nome': nome,
      'Porção': porcao,
      'Carboidratos': carboidratos,
      'Proteínas': proteinas,
      'Gorduras': gorduras,
      'Calorias': calorias,
      'createdAt': Timestamp.now(),
    });

    print('Receita adicionada');
  }


}
