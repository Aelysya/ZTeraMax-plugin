module Battle
  module Effects
    class ZPower < PokemonTiedEffectBase
      # Create a new Pokemon tied effect
      # @param logic [Battle::Logic]
      # @param pokemon [PFM::PokemonBattler]
      def initialize(logic, pokemon)
        super
        self.counter = 1
      end

      # Get the name of the effect
      # @return [Symbol]
      def name
        return :z_power
      end

      # Return the specific proceed_internal if the condition is fulfilled
      # @param user [PFM::PokemonBattler]
      # @param targets [Array<PFM::PokemonBattler>]
      # @param move [Battle::Move]
      def specific_proceed_internal(user, targets, move)
        return :proceed_internal_z_move
      end
    end
  end
end
