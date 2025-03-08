module Battle
  class Logic
    module LogicZTeraMaxDynPlugin
      # Get the Dynamax helper
      # @return [Dynamax]
      attr_reader :dynamax

      # Create a new Logic instance
      # @param scene [Scene] scene that hold the logic object
      def initialize(scene)
        # Dynamax helper
        @dynamax = Dynamax.new(scene)
        super(scene)
      end
    end

    prepend LogicZTeraMaxDynPlugin

    # Logic for Dynamax
    class Dynamax
      # List of tools that allow Dynamax
      DYNAMAX_TOOLS = %i[dynamax_band]

      # Type to Max Moves linking
      MAX_MOVES = {
        normal: :max_strike,
        fighting: :max_knuckle,
        flying: :max_airstream,
        poison: :max_ooze,
        ground: :max_quake,
        rock: :max_rockfall,
        bug: :max_flutterby,
        ghost: :max_phantasm,
        steel: :max_steelspike,
        fire: :max_flare,
        water: :max_geyser,
        grass: :max_overgrowth,
        electric: :max_lightning,
        psychic: :max_mindstorm,
        ice: :max_hailstorm,
        dragon: :max_wyrmwind,
        dark: :max_darkness,
        fairy: :max_starfall
      }

      # Create the Dynamax logic
      # @param scene [Battle::Scene]
      def initialize(scene)
        @scene = scene
        @used_dynamax_tool_bags = []
      end

      # Determines if a given Pokémon can Dynamax.
      # @param pokemon [Pokemon] The Pokémon to check.
      # @return [Boolean] True if the Pokémon can Dynamax, false otherwise.
      def can_pokemon_dynamax?(pokemon)
        return false unless DYNAMAX_TOOLS.any? { |tool| pokemon.bag.contain_item?(tool) }
        return false if pokemon.from_party? && any_dynamax_player_action?
        return false if pokemon.mega_evolved? || pokemon.holds_z_crystal?

        return !@used_dynamax_tool_bags.include?(pokemon.bag)
      end

      # Updates the moveset of a given Pokémon
      # @param pokemon [Pokemon] The Pokémon whose moveset is to be updated.
      # @param z_crystal_activated [Boolean] Whether to set the moveset to the Dynamax state or the original state.
      def update_moveset(pokemon, dynamax_activated)
        if dynamax_activated
          pokemon.effects.add(Effects::Dynamaxed.new(@logic, pokemon))
          pokemon.moveset.each_with_index do |move, i|
            pokemon.original_moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, move.pp, move.ppmax, @scene)

            if move.status?
              pokemon.moveset[i] = Battle::Move[:s_max_guard].new(:max_guard, move.pp, move.ppmax, @scene)
              pokemon.moveset[i].is_max = true
            else
              max_move_symbol = MAX_MOVES[data_move(move.db_symbol).type]
              pokemon.moveset[i] = Battle::Move[data_move(max_move_symbol).be_method].new(max_move_symbol, @scene, move)
            end
          end
        else
          pokemon.reset_to_original_moveset
        end
      end

      # Marks the given Pokémon's trainer as having used the Dynamax.
      # @param pokemon [Pokemon] The Pokémon that has used the Dynamax.
      # @return [void]
      def mark_as_dynamax_used(pokemon)
        @used_dynamax_tool_bags << pokemon.bag
      end

      private

      # Function that checks if any action of the player is a Dynamax
      # @return [Boolean] true if any player action is an Dynamax command, false otherwise.
      def any_dynamax_player_action?
        @scene.player_actions.any? { |action| action.is_a?(Actions::Dynamax) }
      end
    end
  end
end
