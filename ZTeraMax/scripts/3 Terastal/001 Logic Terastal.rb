module Battle
  class Logic
    module TerastalPlugin
      # Get the Terastal helper
      # @return [Terastal]
      attr_reader :terastal

      # Create a new Logic instance
      # @param scene [Scene] scene that holds the logic object
      def initialize(scene)
        # Terastal helper
        @terastal = Terastal.new(scene)
        super
      end
    end
    prepend TerastalPlugin

    # Logic for Terastal
    class Terastal
      # List of tools that allow Terastal
      TERASTAL_TOOLS = %i[tera_orb]

      # Create the Terastal logic
      # @param scene [Battle::Scene]
      def initialize(scene)
        @scene = scene
        @used_terastal_tool_bags = []
      end

      # Determines if a given Pokémon can Terastal.
      # @param pokemon [Pokemon] The Pokémon to check.
      # @return [Boolean] True if the Pokémon can Terastallize, false otherwise.
      def can_pokemon_terastal?(pokemon)
        return false unless TERASTAL_TOOLS.any? { |tool| pokemon.bag.contain_item?(tool) }
        return false if pokemon.from_party? && any_terastal_player_action?
        return false if pokemon.can_mega_evolve? || pokemon.mega_evolved? || pokemon.holds_z_crystal?

        return !@used_terastal_tool_bags.include?(pokemon.bag)
      end

      # Marks the given Pokémon's trainer as having Terastallized.
      # @param pokemon [Pokemon] The Pokémon that has Terastallized.
      # @return [void]
      def mark_as_terastal_used(pokemon)
        @used_terastal_tool_bags << pokemon.bag
      end

      private

      # Function that checks if any action of the player is a Terastal
      # @return [Boolean] true if any player action is an Terastal command, false otherwise.
      def any_terastal_player_action?
        @scene.player_actions.flatten.any? { |action| action.is_a?(Actions::Terastal) }
      end
    end

    BattleEndHandler.register('PSDK unterastallize') do |_, players_pokemon|
      players_pokemon.each { |pokemon| pokemon.terastallized = false }
    end

    EndTurnHandler.register_end_turn_event('PSDK end turn: Unterastallize') do |logic, _, _|
      logic.all_battlers do |battler|
        next unless battler.dead? && battler.terastallized

        battler.terastallized = false
      end
    end
  end
end
