# fridge_app

A Flutter project.

# Application de gestion des dates de péremption dans frigo
## Fonctionnalités principales :
- [x] Implémentation de la sauvegarde des produits en BDD sqlite (ajout, suppression)
- [x] Affichage des produits en une liste scrollable **[V1]**
- [x] Affichage des produits en une liste depuis BDD **[V2]**
- [x] (UI) Affichage du produit avec couleur selon priorité, date, ... **[V3]** liste
- [x] Scanning de codes barres avec un simple bouton
- [x] Recherche du code barre grâce à un appel API pour récupérer les infos de base du produit 
- [x] [BUG] Mise à jour de la recherche de code barre avec nouvelle version de l'API
- [ ] [BUG] Ajout gestion de connexion à internet pour les requêtes de codes barre
- [ ] Affichage du nom du produit avec sa descripton, possibilité d'édition, photo
- [ ] Implémentation de la mise à jour des infos produit
- [ ] Affichage de toutes les infos avec possibilité de les modifier
- [ ] Implémentation du tri de la liste en fonction de l'ordre des dates
- [ ] Implémentation d'un système de notification quand un produit se rapproche de sa date limite
- [ ] Ajout d'un bouton pour retourner en haut de la liste
- [ ] Implémentation barre de recherche pour chercher produit par nom ou code barre
- [ ] Affichage par date/nom/catégorie
  
## Fonctionnalités avancées
- [ ] Mise en cache/BDD des codes barre pour recherche du nom plus rapide
- [ ] Sélecteur "se souvenir du produit"
- [ ] Quand on scan un produt existant ou ajout produit de même nom : Popup avec quantité et options (supprimer, ajouter plusieurs produit) si scan du même code barre (***mettre un message pour proposer d'ajouter une quantité au produit existant, sinon supprimer***)
- [ ] Scanning de la date de péremption OCR
- [ ] Panneau de gestion des notifications pour pouvoir régler le délai ... 
- [ ] Gestion des quantités 
- [ ] Implémenter l'édition et la suppression des produits avec swipe droit/gauche de la card 
- [ ] Versions FR / EN
- [ ] Implémentation de la proposition de recettes 