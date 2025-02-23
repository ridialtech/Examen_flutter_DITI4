import 'package:flutter/material.dart';
import 'produit.dart';
import 'produit_service.dart';

class ProduitPage extends StatefulWidget {
  const ProduitPage({Key? key}) : super(key: key);

  @override
  State<ProduitPage> createState() => _ProduitPageState();
}

class _ProduitPageState extends State<ProduitPage> {
  final ProduitService _produitService = ProduitService();
  List<Produit> _produits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProduits();
  }

  Future<void> _loadProduits() async {
    try {
      final produits = await _produitService.getProduits();
      produits.sort((a, b) => b.id.compareTo(a.id));
      setState(() {
        _produits = produits;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onAddPressed() {
    showDialog(
      context: context,
      builder: (_) => _ProduitDialog(
        onSaved: (produit) async {
          await _produitService.addProduit(produit);
          Navigator.pop(context);
          await _loadProduits();
        },
      ),
    );
  }

  void _onUpdatePressed(Produit produit) {
    showDialog(
      context: context,
      builder: (_) => _ProduitDialog(
        existingProduit: produit,
        onSaved: (updatedProduit) async {
          await _produitService.updateProduit(updatedProduit);
          Navigator.pop(context);
          await _loadProduits();
        },
      ),
    );
  }

  Future<void> _onDeletePressed(int id) async {
    try {
      await _produitService.deleteProduit(id);
      await _loadProduits();
    } catch (e) {
      debugPrint('Erreur de suppression: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des produits"),
        backgroundColor: const Color(0xFF017FFF), // Couleur #17f pour l'AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white), // Icône blanche pour contraster
            onPressed: _onAddPressed,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _produits.length,
              itemBuilder: (context, index) {
                final p = _produits[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('${p.code} - ${p.designation}'),
                    subtitle: Text('ID: ${p.id} | Prix: ${p.prix}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFF017FFF)), // Icône bleue
                          onPressed: () => _onUpdatePressed(p),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), // Icône rouge pour la suppression
                          onPressed: () => _onDeletePressed(p.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Ajout du copyright en bas de la page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '© 2025 Cheikh Ibra Faye - Examen DITI4 Flutter',
              style: TextStyle(
                color: Colors.grey[600], // Couleur grise pour le texte
                fontSize: 14, // Taille de police
                fontStyle: FontStyle.italic, // Style italique
              ),
              textAlign: TextAlign.center, // Centrer le texte
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddPressed,
        backgroundColor: const Color(0xFF017FFF), // Couleur #17f pour le bouton flottant
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _ProduitDialog extends StatefulWidget {
  final Produit? existingProduit;
  final Function(Produit) onSaved;

  const _ProduitDialog({
    Key? key,
    this.existingProduit,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<_ProduitDialog> createState() => _ProduitDialogState();
}

class _ProduitDialogState extends State<_ProduitDialog> {
  late TextEditingController _codeController;
  late TextEditingController _designationController;
  late TextEditingController _prixController;
  late TextEditingController _dateExpController;
  late TextEditingController _descriptionController;

  bool get _isEditing => widget.existingProduit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final p = widget.existingProduit!;
      _codeController = TextEditingController(text: p.code);
      _designationController = TextEditingController(text: p.designation);
      _prixController = TextEditingController(text: p.prix.toString());
      _dateExpController = TextEditingController(text: p.dateExpiration ?? '');
      _descriptionController = TextEditingController(text: p.description ?? '');
    } else {
      _codeController = TextEditingController();
      _designationController = TextEditingController();
      _prixController = TextEditingController();
      _dateExpController = TextEditingController();
      _descriptionController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Modifier Produit' : 'Ajouter Produit'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Code'),
              enabled: !_isEditing,
            ),
            TextField(
              controller: _designationController,
              decoration: const InputDecoration(labelText: 'Désignation'),
            ),
            TextField(
              controller: _prixController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Prix'),
            ),
            TextField(
              controller: _dateExpController,
              decoration: const InputDecoration(labelText: 'Date expiration'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler', style: TextStyle(color: Color(0xFF017FFF))), // Texte bleu
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF017FFF), // Couleur #17f pour le bouton
          ),
          child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _onSave() {
    final code = _codeController.text;
    final designation = _designationController.text;
    final prix = double.tryParse(_prixController.text) ?? 0.0;
    final dateExp = _dateExpController.text.isEmpty ? null : _dateExpController.text;
    final description = _descriptionController.text.isEmpty ? null : _descriptionController.text;

    if (_isEditing) {
      final old = widget.existingProduit!;
      final updated = Produit(
        id: old.id,
        code: old.code,
        designation: designation,
        prix: prix,
        dateExpiration: dateExp,
        description: description,
      );
      widget.onSaved(updated);
    } else {
      final newProduit = Produit(
        id: 0,
        code: code,
        designation: designation,
        prix: prix,
        dateExpiration: dateExp,
        description: description,
      );
      widget.onSaved(newProduit);
    }
  }
}