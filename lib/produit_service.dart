import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'produit.dart';

class ProduitService {
  // URL du serveur local json-server (assurez-vous de l'exécuter avec "json-server --watch db.json --port 3000")
  final String baseUrl = 'http://10.0.2.2:3000/products';

  // GET : Récupère la liste des produits
  Future<List<Produit>> getProduits() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Produit.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }

  // POST : Ajoute un produit en attribuant un nouvel id (auto-incrémenté)
  Future<Produit> addProduit(Produit produit) async {
    // Récupère la liste actuelle pour déterminer le plus grand id
    List<Produit> currentProducts = await getProduits();
    int newId = 1;
    if (currentProducts.isNotEmpty) {
      newId = currentProducts.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
    }

    // Crée un nouveau produit avec le nouvel id
    Produit newProduit = Produit(
      id: newId,
      code: produit.code,
      designation: produit.designation,
      prix: produit.prix,
      dateExpiration: produit.dateExpiration,
      description: produit.description,
    );

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newProduit.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Produit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de l\'ajout du produit');
    }
  }




  // PUT : Met à jour un produit existant
  // Future<Produit> updateProduit(Produit produit) async {
  //   final url = '$baseUrl/${produit.id}';
  //   final response = await http.put(
  //     Uri.parse(url),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(produit.toJson()),
  //   );
  //   if (response.statusCode == 200) {
  //     return Produit.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Erreur lors de la mise à jour du produit');
  //   }
  // }



  Future<Produit> updateProduit(Produit produit) async {
    final url = '$baseUrl/${produit.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produit.toJson()),
    );
    debugPrint('Update (PUT) response: code: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode == 200) {
      return Produit.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour du produit, code ${response.statusCode}');
    }
  }



  // // DELETE : Supprime un produit
  // Future<void> deleteProduit(int produitId) async {
  //   final url = '$baseUrl/$produitId';
  //   final response = await http.delete(Uri.parse(url));
  //   if (response.statusCode != 200) {
  //     throw Exception('Erreur lors de la suppression du produit');
  //   }
  // }

  Future<void> deleteProduit(int produitId) async {
    // Utilisation de 10.0.2.2 pour accéder au serveur local depuis l'émulateur Android
    final String baseUrl = 'http://10.0.2.2:3000/products';
    final url = '$baseUrl/$produitId';
    final response = await http.delete(Uri.parse(url));
    debugPrint('Tentative de suppression du produit id: $produitId');
    debugPrint('Delete response: code: ${response.statusCode}, body: ${response.body}');
    // Accepte 200 ou 204 comme codes de succès
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression du produit, code ${response.statusCode}');
    }
  }



}
