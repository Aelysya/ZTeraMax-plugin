module Battle
  module Effects
    class Dynamaxed < PokemonTiedEffectBase
      # Create a new Pokemon tied effect
      # @param logic [Battle::Logic]
      # @param pokemon [PFM::PokemonBattler]
      def initialize(logic, pokemon)
        super
        self.counter = 3
      end

      # Get the name of the effect
      # @return [Symbol]
      def name
        return :dynamaxed
      end

      # Function called when the effect has been deleted from the effects handler
      def on_delete
        # @logic.scene.display_message_and_wait(parse_text_with_pokemon(20_000, XX, @pokemon))
        @pokemon.reset_to_original_moveset
      end
    end

    class MaxGuard < Protect
      # Get the name of the effect
      # @return [Symbol]
      def name
        return :max_guard
      end
    end
  end
end
