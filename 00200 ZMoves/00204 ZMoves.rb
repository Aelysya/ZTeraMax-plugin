module Battle
  class Logic
    # Logic for Z-Moves
    class ZMoves
      # List of tools that allow Z-Moves
      Z_MOVES_TOOLS = %i[z_ring z_power_ring]

      # List of Z-crystals
      Z_CRYSTALS = %i[firium_z waterium_z]

      # Create the ZMoves checker
      # @param scene [Battle::Scene]
      def initialize(scene)
        @scene = scene
        # List of bags that already used a Z move
        # @type [Array<PFM::Bag>]
        @used_z_moves_tool_bags = []
      end

      # Test if a Pokemon can use a Z move
      # @param pokemon [PFM::PokemonBattler] Pokemon that should use a Z move
      # @return [Boolean]
      def can_pokemon_use_z_move?(pokemon)
        bag = pokemon.bag
        return false unless Z_MOVES_TOOLS.any? { |item_db_symbol| bag.contain_item?(item_db_symbol) }
        return false if pokemon.from_party? && any_z_move_player_action?

        return !@used_z_moves_tool_bags.include?(bag) && pokemon_holds_z_crystal?(pokemon)
      end

      def pokemon_holds_z_crystal?(pokemon)
        return true
      end

      # Mark a Pokemon used a Z move
      # @param pokemon [PFM::PokemonBattler]
      def mark_as_used_z_move(pokemon)
        @used_z_moves_tool_bags << pokemon.bag
      end

      # Give the name of the Z move tool used by the trainer
      # @param pokemon [PFM::PokemonBattler]
      # @return [String]
      def mega_tool_name(pokemon)
        bag = pokemon.bag
        symbol = Z_MOVES_TOOLS.find { |item_db_symbol| bag.contain_item?(item_db_symbol) }
        return data_item(symbol || 0).name
      end

      private

      # Function that checks if any action of the player is a Z move
      # @return [Boolean]
      def any_z_move_player_action?
        @scene.player_actions.any? { |actions| actions.is_a?(Array) }
      end
    end
  end
end
