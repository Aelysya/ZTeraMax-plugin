# ZTeraMax-plugin
This plugins aims to add the Z-Moves, Dynamax and Terastal functionalities to a PSDK fangame

## Useful links

-   [Discord server](https://discord.gg/0noB0gBDd91B8pMk)
-   [Bulbapedia link to Z-Moves](https://bulbapedia.bulbagarden.net/wiki/Z-Move)
-   [Bulbapedia link to Dynamax](https://bulbapedia.bulbagarden.net/wiki/Dynamax)
-   [Bulbapedia link to Terastal](https://bulbapedia.bulbagarden.net/wiki/Terastal_phenomenon)

## How to use

First, it is highly recommended that you use a datapack that you can find [here](https://github.com/PokemonWorkshop/GameDataPacks/tree/gen-packs). Many of the data used in this plugin are erroneous in the base data of Studio project, so most of the functionalities will simply not work.

To use this plugin with your fangame, follow these steps:
  - Download the latest release from this repository
  - Unzip the archive,  you should find a file called `ZTeraMax.psdkplug`.
  - Put this file in the `scripts` folder at the root of your project
  - Go back to your project's root folder, and run the `cmd.bat` executable, a terminal should open up
  - Enter the command `./psdk --util=plugin load` to install the plugin

**Note on move animations**: The Z-Moves and Max-Moves have no animation yet, you can either do them by yourself if you want, or you can wait for someone else to volunteer to do them. Either way, it is useless to complain about them being missing.

#### Configuration
You may have a custom Battle UI for your fangame, and if so, you may have changed the move selection buttons. By default, this plugins shortens the moves names so they span a maximum of 15 characters. This is to prevent the veeeeeery long Z-Moves names from going out of the window. If you already have a way to deal with this kind of problems or if the shortening isn't necessary for your game, you can go to the config file `Data/configs/z_tera_max_config.json` and modify the value of `useBuiltinMoveNameSlice` to false.

#### Z-Moves

Z-Moves have been implemented in the plugin to function as close as possible to the official way, you can have a lot of information about them on the [Bulbapedia page for Z-Moves](https://bulbapedia.bulbagarden.net/wiki/Z-Move)
To use Z-Moves in battle, here's what your players need:
- A Z-tool, which is either a Z-Ring, or a Z-Power Ring
- Some Z-Crystals

When you give a Z-Crystal to your players, be sure to give them one that contains a '2' at the end of their db_symbol (e.g. normalium_z2). In the database these are the bigger crystals. When your players will give a crystal to their Pokémon, it will automatically create the right crystal, which is the smaller version in the database. When they try to retrieve a crystal from their Pokémon, it will not be put back in the bag, just deleted. This mimics the ways these items work in the official games.

#### Dynamax
TODO

#### Terastal
TODO

## Credits

#### Z-Moves

- Main developers:
  - Aelysya
  - Lexio
  - Ota

- Reviewer:
  - Zøzo
