module Battle
  class Logic
    # Logic for Z-Moves
    class ZMoves
      # List of tools that allow Z-Moves
      Z_MOVES_TOOLS = %i[z_ring z_power_ring]

      # List of basic Z-crystals
      Z_CRYSTALS = {
        normalium_z: { type: :normal, physical: :breakneck_blitz, special: :breakneck_blitz2 },
        fightinium_z: { type: :fighting, physical: :all_out_pummeling, special: :all_out_pummeling2 },
        flyinium_z: { type: :flying, physical: :supersonic_strike, special: :supersonic_strike2 },
        poisonium_z: { type: :poison, physical: :acid_downpour, special: :acid_downpour2 },
        groundium_z: { type: :ground, physical: :tectonic_rage, special: :tectonic_rage2 },
        rockium_z: { type: :rock, physical: :continental_crush, special: :continental_crush2 },
        buginium_z: { type: :bug, physical: :savage_spin_out, special: :savage_spin_out2 },
        ghostium_z: { type: :ghost, physical: :never_ending_nightmare, special: :never_ending_nightmare2 },
        steelium_z: { type: :steel, physical: :corkscrew_crash, special: :corkscrew_crash2 },
        firium_z: { type: :fire, physical: :inferno_overdrive, special: :inferno_overdrive2 },
        waterium_z: { type: :water, physical: :hydro_vortex, special: :hydro_vortex2 },
        grassium_z: { type: :grass, physical: :bloom_doom, special: :bloom_doom2 },
        electrium_z: { type: :electric, physical: :gigavolt_havoc, special: :gigavolt_havoc2 },
        psychium_z: { type: :psychic, physical: :shattered_psyche, special: :shattered_psyche2 },
        icium_z: { type: :ice, physical: :subzero_slammer, special: :subzero_slammer2 },
        dragonium_z: { type: :dragon, physical: :devastating_drake, special: :devastating_drake2 },
        darkinium_z: { type: :dark, physical: :black_hole_eclipse, special: :black_hole_eclipse2 },
        fairium_z: { type: :fairy, physical: :twinkle_tackle, special: :twinkle_tackle2 }
      }

      # Create the Z-Moves checker
      # @param scene [Battle::Scene]
      def initialize(scene)
        @scene = scene
        # List of bags that already used a Z-Move
        # @type [Array<PFM::Bag>]
        @used_z_moves_tool_bags = []
      end

      # Test if a Pokemon currently holds a Z-Crystal
      # @param pokemon [PFM::PokemonBattler] Pokemon on which to verify the held item
      # @return [Boolean]
      def pokemon_holds_z_crystal?(pokemon)
        return Z_CRYSTALS.keys.include?(pokemon.item_db_symbol)
      end

      # Test if a Pokemon can use a Z-Move
      # @param pokemon [PFM::PokemonBattler] Pokemon that should use a Z-Move
      # @return [Boolean]
      def can_pokemon_use_z_move?(pokemon)
        bag = pokemon.bag
        return false unless Z_MOVES_TOOLS.any? { |item_db_symbol| bag.contain_item?(item_db_symbol) }
        return false if pokemon.from_party? && any_z_move_player_action?

        return !@used_z_moves_tool_bags.include?(bag) && pokemon_holds_z_crystal?(pokemon)
      end

      # Refresh the movepool of the Pokémon to replace basic moves by Z-Moves, or to revert it to its original state
      # @param pokemon [PFM::PokemonBattler] Pokemon that movepool should be refreshed
      # @param z_crystal_activated [Boolean] Whether to set the movepool to the Z-Move or the original state
      def update_movepool(pokemon, z_crystal_activated)
        return unless pokemon_holds_z_crystal?(pokemon)

        if z_crystal_activated
          pokemon.moveset.map! do |move|
            next move unless data_type(move.type).db_symbol == Z_CRYSTALS[pokemon.item_db_symbol][:type]
            next move if data_move(move.db_symbol).category == :status

            Battle::Move[:s_z_move].new(Z_CRYSTALS[pokemon.item_db_symbol][data_move(move.db_symbol).category], @scene, move)
          end
        else
          pokemon.original.moveset.map.with_index do |skill, i|
            pokemon.moveset[i] = Battle::Move[skill.symbol].new(skill.db_symbol, skill.pp, skill.ppmax, @scene)
          end
        end
      end

      # Mark a Pokemon used a Z-Move
      # @param pokemon [PFM::PokemonBattler]
      def mark_as_used_z_move(pokemon)
        @used_z_moves_tool_bags << pokemon.bag
      end

      # Give the name of the Z-Move tool used by the trainer
      # @param pokemon [PFM::PokemonBattler]
      # @return [String]
      def mega_tool_name(pokemon)
        bag = pokemon.bag
        symbol = Z_MOVES_TOOLS.find { |item_db_symbol| bag.contain_item?(item_db_symbol) }
        return data_item(symbol || 0).name
      end

      private

      # Function that checks if any action of the player is a Z-Move
      # @return [Boolean]
      def any_z_move_player_action?
        @scene.player_actions.any? { |actions| actions.is_a?(Array) }
      end
    end
  end
end
