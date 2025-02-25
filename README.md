# ZTeraMax-plugin
This plugins aims to add the Z-Moves, Dynamax and Terastal functionalities to a PSDK fangame

## Useful links

-   [Discord server](https://discord.gg/0noB0gBDd91B8pMk)
-   [Bulbapedia link to Z-Moves](https://bulbapedia.bulbagarden.net/wiki/Z-Move)
-   [Bulbapedia link to Dynamax](https://bulbapedia.bulbagarden.net/wiki/Dynamax)
-   [Bulbapedia link to Terastal](https://bulbapedia.bulbagarden.net/wiki/Terastal_phenomenon)

## How to use

First, it is highly recommended that you use a datapack that you can find [here](https://github.com/PokemonWorkshop/GameDataPacks/tree/gen-packs). Many of the data used in this plugin are erroneous in the base data of a default Studio project, so most of the functionalities will simply not work.

You may have a custom Battle UI for your fangame, and if so, you may have changed the move selection buttons. By default, this plugins slices the moves names so they span a maximum of 15 characters. This is to prevent the veeeeeery long Z-Moves names from going out of the window. If you already have a way to deal with this kind of problems or if the slicing isn't necessary for your game, you can head in the config file located here: `Data/configs/z_tera_max_config.json` and modify the value of `useBuiltinMoveNameSlice` to false.

**Note on move animations**: The Z-Moves have no animation yet, you can either do them by yourself if you want, or you can wait for someone else to volunteer to do them. Either way, it is useless to complain about them being missing.

### Z-Moves

When you give a crystal to your players, be sure to give them the ones that contain a '2' at the end (e.g. normalium_z2). In the database these are the bigger crystals.
When the players choose to give a crystal to their Pokémon, it will automatically create the right crystal, which is the smaller version in the database.
When they try to retrieve the crystal from their Pokémon, it will not be put back in the bag, just deleted. This mimics the ways these items work in the official games.

### Dynamax
TODO

### Terastal
TODO

## Credits

### Z-Moves

- Main developers: Aelysya, Lexio, Ota
- Reviewers: Zøzo
