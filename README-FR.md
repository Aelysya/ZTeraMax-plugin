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

Les capacités Z ont été implémentés dans le plugin pour avoir un fonctionnement aussi proche que possible de la manière officielle, pour avoir toutes les informations à leur sujet sur la [page Bulbapedia pour les capacités Z](https://bulbapedia.bulbagarden.net/wiki/Z-Move).
Pour utiliser les capacités Z en combat, voici ce dont vos joueurs ont besoin :
- Un anneau Z, qui est soit un Z-Ring, soit un Z-Power Ring.
- Des Cristaux Z

Lorsque vous donnez un cristaal Z à vos joueurs, assurez-vous de leur en donner un qui contient un '2' à la fin de leur db_symbole (ex: normalium_z2). Dans la base de données, il s'agit des plus gros cristaux. Lorsque le joueur choisit de donner un cristal à son Pokémon, le plugin crée automatiquement le bon cristal, qui sera la version plus petite dans la base de données. Lorsqu'ils essaieront de récupérer le cristal de leur Pokémon, celui-ci ne sera pas remis dans le sac, il sera simplement supprimé. Cela reproduit le fonctionnement de ces objets dans les jeux officiels.

#### Dynamax
TODO

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