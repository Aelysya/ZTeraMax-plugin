module Battle
  class Logic
    # Logic for Z-Moves
    class ZMoves
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
            pokemon.moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, move.pp, move.ppmax, @scene)
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

      # Replaces a Pokémon's move with its corresponding Z-Move if the Pokémon is holding the correct Z-Crystal.
      #
      # @param pokemon [Pokemon] The Pokémon whose move is to be replaced.
      # @param move [Move] The move to be potentially replaced with a Z-Move.
      # @return [Move] The original move if the Pokémon is not holding the correct Z-Crystal, otherwise the corresponding Z-Move.
      def replace_with_type_z_move(pokemon, move)
        return move unless data_type(move.type).db_symbol == TYPE_Z_CRYSTALS[pokemon.item_db_symbol][:type]

        replacement_move = Battle::Move[:s_type_z_move].new(TYPE_Z_CRYSTALS[pokemon.item_db_symbol][data_move(move.db_symbol).category], @scene, move)
        replacement_move.is_z = true

        return replacement_move
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

      private

      # Replaces a Pokémon's move with its signature Z-Move if conditions are met.
      #
      # @param pokemon [Pokemon] The Pokémon whose move is to be replaced.
      # @param move [Move] The move to be potentially replaced.
      # @return [Move] The original move or the signature Z-Move if conditions are met.
      def replace_with_signature_z_move(pokemon, move)
        crystal_data = SIGNATURE_Z_CRYSTALS[pokemon.item_db_symbol]
        data = crystal_data.find { |entry| entry[:specie] == pokemon.db_symbol && entry[:forms].include?(pokemon.form) }

        return move unless move.db_symbol == data[:base_move]

        replacement_move = Battle::Move[data[:be_method]].new(data[:zmove], move.pp.positive? ? 1 : 0, 1, @scene)
        replacement_move.is_z = true

        return replacement_move
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
