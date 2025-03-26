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

Dynamax has been implemented in the plugin to function as close as possible to the official way, you can have a lot of information about them on the [Bulbapedia page for Dynamax](https://bulbapedia.bulbagarden.net/wiki/Dynamax)
To use the Dynamax in battle, your players will need to be given a Dynamax Band.

By default **ALL** Pokémon will be generated with a 10% chance to have the Gigantamax factor, not only the ones that do have a Gigantamax Form. However, the symbol on the summary will only appear if the Pokémon has a Gigantamax form available, see the GIGANTAMAX_SPECIES array in `2 Dynamax/3 UI/001 Gigantamax Icon Summary.rb` for official Gigantamax species. You can monkey-patch this array to add your custom Gigantamax Pokémon.
The 10% value is customizable, you can change the value of the `gigantamaxChance` in the config file `Data/configs/z_tera_max_config.json`.

To create custom Gigantamax Pokémon, you will have to do a small manipulation of the JSON files. Please note that manipulating the JSON files is a very risky thing to do if you don't **precisely** know what you're doing. So, if you want to add your custom Gigantamax Pokémon, follow exactly these steps:
- Open Pokémon Studio
- Open the database page of the Pokémon you want to give a Gigantamax form to
- Click on "New form" button in the top right corner, edit anything you want
- Click on "Add the form" and remember the number that is shown beside the form's name you just created
- Open the folder that contains your project and follow this folder path: `Data/Studio/pokemon`
- Search for the file that has the name of your Pokémon and open it in a text editor
- Hit CTRL + F keys and enter this: `"form": X,`, replace X by the number you remembered
- Once your text editor shows you the place where this text is, change the number to 40
- **DO NOT TOUCH ANYTHING ELSE IN THE FILE UNLESS YOU KNOW EXACTLY WHAT YOU'RE DOING**, you can modify the sprites from Studio though

To give the Gigantamax factor to a Pokémon (or remove it) you will have to script it by yourself. If you want to follow the official way, check this [link](https://bulbapedia.bulbagarden.net/wiki/Master_Dojo#Max_Soup).
The attribute to modify is `gigantamax_factor`, you can do it by calling `$actors[gv[43]].gigantamax_factor = (true|false)` (check the Motisma devices in the Demo's laboratory for more information on how to modify a Pokémon's attributes from an event)

In official games, Dynamax is only allowed in some battles such gym and league challenges. If you want to mimic this, a switch is used to allow or not the use of Dynamax in battle. By default the switch number is 113, this is a completely random choice and may conflict with one your switches, if that's the case, you can change the switch number by going in the config file `Data/configs/z_tera_max_config.json` and modifying the `dynamaxEnabledSwitch` field value.

#### Terastal
TODO

## Credits

- Main developers:
  - Aelysya
  - Lexio
  - Ota

- Reviewer:
  - Zøzo
