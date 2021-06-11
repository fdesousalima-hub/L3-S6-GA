Rapport Projet GA
--

## Indications

### Notation

Ce document détaille le bon fonctionnement du programme, ainsi que des instructions de compilation et d'exécution.
Afin de rendre votre lecture plus facile, voici quelques détails sur certains caractères utilisés:
* Les caractères compris entre `<>` indiquent que c'est à l'utilisateur de completer ces champs.

### Séparation

Au niveau des fichiers sources, ils sont séparés en 5:
* Un fichier `ast.ml` Fichier qui définit l'arbre grammatical
* Un fichier `lexer.mll` Fichier qui crée les tokens
* Un fichier `parser.mly` Fichier qui crée l'arbre grammatical
* Un fichier `turtle.ml` Fichier qui interprète l'arbre grammatical
* Un fichier `main.ml` Fichier qui execute le programme

Pour la compilation, nous avons fait le choix d'un `Makefile`

Dans le cas où ce rapport ne répondrait pas à une de vos questions, n'hésitez pas à contacter l'un d'entre nous (Voir coordonnées ci-dessous).

## Etudiants
| Prénom | NOM | Numéro étudiant | Groupe | Pseudo Git | Mail | Discord |
| --- | --- | --- | --- | --- | --- | --- |
| Fabio | DE SOUSA LIMA | 71802806 | Groupe 2 | @desousal | fabio.jorge2000@hotmail.fr | Asuos#2448 |
| Clément | MEBARKI | 71800676 | Groupe 2 | @mebarkic | m_clement@live.fr | veveles#3811 |

## Compilation & Exécution

### Compilation

Pour compiler le projet:
```
make
```
Pour nettoyer le repertoire:
```
make clean
```

### Exécution

Pour exécuté le projet:
```
./parser < <chemin_vers_le_fichier_à_tester> 
```

## Projet

Ce projet consiste à concevoir et implanter un interpréteur pour la création d'images.
L'interpreteur prend des instructions dans un fichier puis dessine à l'ecran une image.
Les instructions permettent de déplacer verticalement ou horizontalement le curseur, le cuseur peut etre en position basse (Qui lui permet de dessiné) ou autre. Le curseur peut aussi tourner dans le sens trigonométrique.

### Grammaire

La grammaire du langage est la suivante, les non-terminaux sont en **gras** et en *italiques*, les terminaux (jetons) en non-gras.

* ***programme*** → ***declarations*** ***instruction***
* ***declarations*** → Var identificateur; ***declarations*** | ε
* ***instruction*** → Avance ***expression*** | Tourne ***expression*** | Si ***expression*** Alors ( ***instruction*** ) ***instructionSuite*** | Tantque ***expression*** Faire ***instruction*** | BasPinceau | HautPinceau | Changecouleur identificateur | Changeepaisseur ***expression*** | identificateur = ***expression*** | Debut ***blocInstruction*** Fin
* ***instructionSuite*** → Sinon ***instruction*** | ε
* ***blocInstruction*** → ***instruction***; ***blocInstruction*** | ε
* ***expression*** → nombre ***expressionSuite*** | - ***expression*** | identificateur ***expressionSuite*** | ( ***expression*** ) ***expressionSuite***
* ***expressionSuite*** → \* ***expression*** | / ***expression*** | + ***expression*** | - ***expression*** | ε

avec les dénitions suivantes de jetons:
* identificateur→[a-z][a-zA-Z0-9]*
* nombre→[1-9][0-9]*|0

### Gestion des erreurs

Notre programme traite les erreurs:
* Si une variable est utilisé mais non déclaré
* S'il y a une division par 0
* Si le curseur sort du canevas
* Si la couleur choisie n'existe pas

### Modifications

Nous avons modifié notre programme/grammaire pour ajouter les instructions de type:
* Si ***expression*** Alors ***instruction***
* Si ***expression*** Alors ***instruction*** Sinon ***instruction***
* Tant que ***expression*** Faire ***instruction***
* Changecouleur identificateur
* Changeepaisseur ***expression***

Nous choisissons pour les instructions Si Alors Sinon et Tant que Faire, que Alors et Faire seront exécutées seulement si les expressions sont différente de 0.

Nous avons ajouter aussi les opérations de: (Tout en respectant la priorité)
* multiplication * 
* division / 
* moins unitaire (Exemple: -6)
