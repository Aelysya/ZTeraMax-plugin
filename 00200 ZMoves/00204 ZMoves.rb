module Battle
  class Logic
    # Logic for Z-Moves
    class ZMoves
      # List of tools that allow Z-Moves
      Z_MOVES_TOOLS = %i[z_ring z_power_ring]

      # List of basic Z-crystals
      TYPE_Z_CRYSTALS = {
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

      # List of signature Z-crystals
      SIGNATURE_Z_CRYSTALS = {
        aloraichium_z: [{ specie: :raichu, forms: [1], base_move: :thunderbolt, zmove: :stoked_sparksurfer, be_method: :s_basic }],
        decidium_z: [{ specie: :decidueye, forms: [0], base_move: :spirit_shackle, zmove: :sinister_arrow_raid, be_method: :s_basic }],
        eevium_z: [{ specie: :eevee, forms: [0], base_move: :last_resort, zmove: :extreme_evoboost, be_method: :s_self_stat }],
        incinium_z: [{ specie: :incineroar, forms: [0], base_move: :darkest_lariat, zmove: :malicious_moonsault, be_method: :s_stomp }],
        kommonium_z: [{ specie: :kommo_o, forms: [0], base_move: :clanging_scales, zmove: :clangorous_soulblaze, be_method: :s_self_stat }],
        lunalium_z: [
          { specie: :lunala, forms: [0], base_move: :moongeist_beam, zmove: :menacing_moonraze_maelstrom, be_method: :s_basic },
          { specie: :necrozma, forms: [2], base_move: :moongeist_beam, zmove: :menacing_moonraze_maelstrom, be_method: :s_basic }
        ],
        lycanium_z: [{ specie: :lycanroc, forms: [0, 1, 2], base_move: :stone_edge, zmove: :splintered_stormshards, be_method: :s_ice_spinner }],
        marshadium_z: [{ specie: :marshadow, forms: [0], base_move: :spectral_thief, zmove: :soul_stealing_7_star_strike, be_method: :s_basic }],
        mewnium_z: [{ specie: :mew, forms: [0], base_move: :psychic, zmove: :genesis_supernova, be_method: :s_genesis_supernova }],
        mimikium_z: [{ specie: :mimikyu, forms: [0], base_move: :play_rough, zmove: :let_s_snuggle_forever, be_method: :s_basic }],
        pikanium_z: [{ specie: :pikachu, forms: [0], base_move: :volt_tackle, zmove: :catastropika, be_method: :s_basic }],
        pikashunium_z: [{ specie: :pikachu, forms: [8..14], base_move: :thunderbolt, zmove: :s10_000_000_volt_thunderbolt, be_method: :s_basic }],
        primarium_z: [{ specie: :primarina, forms: [0], base_move: :sparkling_aria, zmove: :oceanic_operetta, be_method: :s_basic }],
        snorlium_z: [{ specie: :snorlax, forms: [0], base_move: :giga_impact, zmove: :pulverizing_pancake, be_method: :s_basic }],
        solganium_z: [
          { specie: :solgaleo, forms: [0], base_move: :sunsteel_strike, zmove: :searing_sunraze_smash, be_method: :s_basic },
          { specie: :necrozma, forms: [1], base_move: :moongeist_beam, zmove: :searing_sunraze_smash, be_method: :s_basic }
        ],
        tapunium_z: [
          { specie: :tapu_koko, forms: [0], base_move: :nature_s_madness, zmove: :guardian_of_alola, be_method: :s_guardian_of_alola },
          { specie: :tapu_lele, forms: [0], base_move: :nature_s_madness, zmove: :guardian_of_alola, be_method: :s_guardian_of_alola },
          { specie: :tapu_bulu, forms: [0], base_move: :nature_s_madness, zmove: :guardian_of_alola, be_method: :s_guardian_of_alola },
          { specie: :tapu_fini, forms: [0], base_move: :nature_s_madness, zmove: :guardian_of_alola, be_method: :s_guardian_of_alola }
        ],
        ultranecrozium_z: [{ specie: :raichu, forms: [0], base_move: :photon_geyser, zmove: :light_that_burns_the_sky, be_method: :s_photon_geyser }]
      }

      # Create the Z-Moves logic
      # @param scene [Battle::Scene]
      def initialize(scene)
        @scene = scene
        @used_z_moves_tool_bags = []
      end

      # Checks if a given Pokémon holds a valid Z-Crystal.
      #
      # A Z-Crystal is considered valid if it is either a type-specific Z-Crystal
      # or a signature Z-Crystal that matches the Pokémon's species and form.
      #
      # @param pokemon [Pokemon] The Pokémon to check.
      # @return [Boolean] True if the Pokémon holds a valid Z-Crystal, false otherwise.
      def pokemon_holds_valid_z_crystal?(pokemon)
        return true if TYPE_Z_CRYSTALS.key?(pokemon.item_db_symbol)
        return false unless SIGNATURE_Z_CRYSTALS.key?(pokemon.item_db_symbol)

        SIGNATURE_Z_CRYSTALS[pokemon.item_db_symbol].any? do |entry|
          entry[:specie] == pokemon.db_symbol && entry[:forms].include?(pokemon.form)
        end
      end

      # Determines if a given Pokémon can use a Z-Move.
      #
      # A Pokémon can use a Z-Move if the following conditions are met:
      # - The Player's bag contains at least one Z-Move tool.
      # - The Pokémon is in the party and Z-Move command has been issued (in case of duo battle).
      # - The Pokémon is not mega-evolved or under primal resurgence.
      # - The Player has not already used a Z-Move during the battle.
      #
      # @param pokemon [Pokemon] The Pokémon to check.
      # @return [Boolean] True if the Pokémon can use a Z-Move, false otherwise.
      def can_pokemon_use_z_move?(pokemon)
        return false unless Z_MOVES_TOOLS.any? { |tool| pokemon.bag.contain_item?(tool) }
        return false if pokemon.from_party? && any_z_move_player_action?
        return false if [30, 31].include?(pokemon.form)

        return !@used_z_moves_tool_bags.include?(pokemon.bag) && pokemon_holds_valid_z_crystal?(pokemon)
      end

      # Updates the moveset of a given Pokémon
      #
      # @param pokemon [Pokemon] The Pokémon whose moveset is to be updated.
      # @param z_crystal_activated [Boolean] Whether to set the moveset to the Z-Move state or the original state.
      #
      # @return [void]
      def update_moveset(pokemon, z_crystal_activated)
        return unless pokemon_holds_valid_z_crystal?(pokemon)

        z_type = TYPE_Z_CRYSTALS.key?(pokemon.item_db_symbol)

        if z_crystal_activated
          pokemon.moveset.each_with_index do |move, i|
            pokemon.original_moveset[i] = Battle::Move.new(move.db_symbol, move.pp, move.ppmax, @scene)

            if move.status? && z_type
              pokemon.moveset[i] = replace_with_status_z_move(pokemon, move)
            else
              pokemon.moveset[i] = z_type ? replace_with_type_z_move(pokemon, move) : replace_with_signature_z_move(pokemon, move)
            end
          end
        else
          pokemon.original_moveset.each_with_index do |move, i|
            pokemon.moveset[i] = Battle::Move.new(move.db_symbol, move.pp, move.ppmax, @scene)
          end
        end
      end

      # Marks the given Pokémon's trainer as having used a Z-Move.
      #
      # @param pokemon [Pokemon] The Pokémon that has used a Z-Move.
      # @return [void]
      def mark_as_z_move_used(pokemon)
        @used_z_moves_tool_bags << pokemon.bag
      end

      private

      # Replaces a Pokémon's move with its corresponding Z-Move if the Pokémon is holding the correct Z-Crystal.
      #
      # @param pokemon [Pokemon] The Pokémon whose move is to be replaced.
      # @param move [Move] The move to be potentially replaced with a Z-Move.
      # @return [Move] The original move if the Pokémon is not holding the correct Z-Crystal, otherwise the corresponding Z-Move.
      def replace_with_type_z_move(pokemon, move)
        return move unless data_type(move.type).db_symbol == TYPE_Z_CRYSTALS[pokemon.item_db_symbol][:type]

        return Battle::Move[:s_type_z_move].new(TYPE_Z_CRYSTALS[pokemon.item_db_symbol][data_move(move.db_symbol).category], @scene, move)
      end

      # Replaces a Pokémon's status move with its corresponding Z-Move if the Pokémon is holding the correct Z-Crystal.
      #
      # @param pokemon [Pokemon] The Pokémon whose move is to be replaced.
      # @param move [Move] The move to be potentially replaced with a Z-Move.
      # @return [Move] The original move if the Pokémon is not holding the correct Z-Crystal, otherwise the corresponding Z-Move.
      def replace_with_status_z_move(pokemon, move)
        return move unless data_type(move.type).db_symbol == TYPE_Z_CRYSTALS[pokemon.item_db_symbol][:type]

        replacement_move = Battle::Move[move.be_method].new(move.db_symbol, move.pp.positive? ? 1 : 0, 1, @scene)
        replacement_move.is_z = true

        return replacement_move
      end

      # Replaces a Pokémon's move with its signature Z-Move if conditions are met.
      #
      # @param pokemon [Pokemon] The Pokémon whose move is to be replaced.
      # @param move [Move] The move to be potentially replaced.
      # @return [Move] The original move or the signature Z-Move if conditions are met.
      def replace_with_signature_z_move(pokemon, move)
        crystal_data = SIGNATURE_Z_CRYSTALS[pokemon.item_db_symbol]
        data = crystal_data.find { |entry| entry[:specie] == pokemon.db_symbol && entry[:forms].include?(pokemon.form) }

        return move unless move.db_symbol == data[:base_move]

        return Battle::Move[data[:be_method]].new(data[:zmove], move.pp.positive? ? 1 : 0, 1, @scene)
      end

      # Function that checks if any action of the player is a Z-Move
      # @return [Boolean] true if any player action is an Z-Move command, false otherwise.
      def any_z_move_player_action?
        @scene.player_actions.any? { |action| action.is_a?(Actions::ZMove) }
      end
    end

    class MegaEvolve
      private

      # Function that checks if any action of the player is a mega evolve
      # @return [Boolean]
      def any_mega_player_action?
        @scene.player_actions.any? { |actions| actions.is_a?(Actions::Mega) }
      end
    end
  end
end
