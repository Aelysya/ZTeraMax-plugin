# ZTeraMax-plugin
Ce plugin a pour but d'ajouter les fonctionnalités des capacités Z, Dynamax et Teracristal à un fangame PSDK.

## Liens utiles

- [Serveur Discord](https://discord.gg/0noB0gBDd91B8pMk)
- [Lien Bulbapedia des capacités Z](https://bulbapedia.bulbagarden.net/wiki/Z-Move)
- [Lien Bulbapedia du Dynamax](https://bulbapedia.bulbagarden.net/wiki/Dynamax)
- [Lien Bulbapedia du Teracristal](https://bulbapedia.bulbagarden.net/wiki/Terastal_phenomenon)

## Utilisation

Tout d'abord, il est fortement recommandé d'utiliser un datapack que vous pouvez trouver [ici](https://github.com/PokemonWorkshop/GameDataPacks/tree/gen-packs). De nombreuses données utilisées dans ce plugin sont erronées dans les données de base d'un projet Studio, donc la plupart des fonctionnalités ne fonctionneront tout simplement pas.

Pour utiliser ce plugin avec votre fangame, suivez ces étapes:
  - Téléchargez la dernière release sur ce repository
  - En décompressant l'archive, vous devriez trouver un fichier `ZTeraMax.psdkplug`
  - Déposez ce fichier dans le dossier `scripts` à la racine de votre projet
  - Revenez dans le dossier racine de votre projet, et lancez l'exécutable `cmd.bat`, un terminal devrait s'ouvrir
  - Entrez la commande `./psdk --util=plugin load` afin d'installer le plugin

**Note sur les animations** : Les capacités Z et capacités Max n'ont pas encore d'animation, vous pouvez soit les faire vous-même si vous le souhaitez, soit attendre que quelqu'un d'autre se porte volontaire pour les faire. Dans tous les cas, il est inutile de se plaindre de leur absence.

#### Configuration
Vous avez peut-être une UI de combat personnalisée pour votre fangame, et si c'est le cas, vous avez peut-être changé les boutons de sélection des capacités. Par défaut, ce plugin raccourcit les noms des capacités pour qu'ils ne dépassent pas 15 caractères. Ceci afin d'éviter que les noms des capacités Z, qui sont parfois trèèèèèèèèèèès longs, ne sortent de la fenêtre. Si vous avez déjà un moyen de gérer ce genre de problème ou si le raccourcissement n'est pas nécessaire pour votre jeu, vous pouvez aller dans le fichier de configuration `Data/configs/z_tera_max_config.json` et modifier la valeur de `useBuiltinMoveNameSlice` en false.

#### Capacités Z

Les capacités Z ont été implémentées dans le plugin pour avoir un fonctionnement aussi proche que possible de la manière officielle, pour avoir toutes les informations à leur sujet sur la [page Bulbapedia pour les capacités Z](https://bulbapedia.bulbagarden.net/wiki/Z-Move).
Pour utiliser les capacités Z en combat, voici ce dont vos joueurs ont besoin :
- Un anneau Z, qui est soit un Bracelet Z, soit un Super Bracelet Z.
- Des Cristaux Z

Lorsque vous donnez un cristal Z à vos joueurs, assurez-vous de leur en donner un qui contient un '2' à la fin de leur db_symbole (ex: normalium_z2). Dans la base de données, il s'agit des plus gros cristaux. Lorsque le joueur choisit de donner un cristal à son Pokémon, le plugin crée automatiquement le bon cristal, qui sera la version plus petite dans la base de données. Lorsqu'ils essaieront de récupérer le cristal de leur Pokémon, celui-ci ne sera pas remis dans le sac, il sera simplement supprimé. Cela reproduit le fonctionnement de ces objets dans les jeux officiels.

#### Dynamax

Le Dynamax a été implémenté dans le plugin pour avoir un fonctionnement aussi proche que possible de la manière officielle, vous pouvez obtenir beaucoup d'informations à son sujet sur la [page Bulbapedia pour le Dynamax](https://bulbapedia.bulbagarden.net/wiki/Dynamax).
Pour utiliser le Dynamax en combat, vos joueurs auront besoin d'un Bandeau Dynamax.

Par défaut, **TOUS** les Pokémon seront générés avec 10% de chances d'avoir le gène Gigamax, pas seulement ceux qui ont une forme Gigamax. Le symbole sur le résumé n'apparaîtra cependant que si une forme Gigamax est disponible, se référer à l'array GIGANTAMAX_SPECIES dans `2 Dynamax/3 UI/001 Gigantamax Icon Summary.rb` pour les espèces Gigamax officielles. Vous pouvez monkey-patch ce tableau pour ajouter vos Pokémon Gigamax custom.
La valeur de 10% est personnalisable, vous pouvez changer la valeur de `defaultGigantamaxChance` dans le fichier de configuration `Data/configs/z_tera_max_config.json`.

Pour donner le gène Gigamax à un Pokémon (ou l'enlever), vous devrez le faire vous-même. Si vous voulez suivre la méthode officielle, consultez ce [lien](https://bulbapedia.bulbagarden.net/wiki/Master_Dojo#Max_Soup).
L'attribut à modifier est `gigantamax_factor`, vous pouvez le faire en appelant `$actors[gv[43]].gigantamax_factor = true|false` (consultez les appareils Motisma dans le laboratoire de la Démo pour plus d'informations sur la façon de modifier les attributs d'un Pokémon à partir d'un événement).

Dans les jeux officiels, le Dynamax n'est autorisé que dans certains combats comme les arènes ou la ligue. Si vous voulez imiter cela, un interrupteur est utilisé pour autoriser ou non l'utilisation de Dynamax dans les combats. Par défaut le numéro du switch est 113, c'est un choix complètement aléatoire et peut entrer en conflit avec un de vos switchs, si c'est le cas, vous pouvez changer le numéro du switch en allant dans le fichier de configuration `Data/configs/z_tera_max_config.json` et en modifiant la valeur du champ `dynamaxEnabledSwitch`.

#### Terastal
TODO

## Crédits

#### Z-Moves

- Main developers: 
  - Aelysya
  - Lexio
  - Ota

- Reviewer:
  - Zøzo

#### Dynamax

- Main developers:
  - Aelysya
  - Ota

- Reviewer:
  -