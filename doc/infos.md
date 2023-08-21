# Application de gestion des dates de péremption dans frigo
## Fonctionnalités principales :
- [x] Implémentation de la sauvegarde des produits en BDD sqlite (ajout, suppression)
- [x] Affichage des produits en une liste scrollable **[V1]**
- [x] Affichage des produits en une liste depuis BDD **[V2]**
- [ ] Scanning de codes barres avec un simple bouton
- [ ] Recherche du code barre grâce à un appel API pour récupérer les infos de base du produit 
- [ ] Affichage du nom du produit avec possibilité d'édition 
- [ ] Implémentation de la mise à jour des infos produit
- [ ] Scanning de la date de péremption ou saisie manuelle
- [ ] Affichage de toutes les infos avec possibilité de les modifier
- [ ] Implémentation du tri de la liste en fonction de l'ordre des dates
- [ ] Implémentation d'un système de notification quand un produit se rapproche de sa date limite
  
## Fonctionnalités avancées
- [ ] Sauvegarde en BDD des renommages custom de produits pour UX plus sympa
- [ ] Suppression du produit si scan du même code barre (***mettre un message pour proposer d'ajouter une quantité au produit existant, sinon supprimer***)
- [ ] Panneau de gestion des notifications pour pouvoir régler le délai ... 
- [ ] Ajout suppression automatique sous critères 
- [ ] implémenter l'édition et la suppression des produits avec swipe droit/gauche de la card 
- [ ] versions FR / EN