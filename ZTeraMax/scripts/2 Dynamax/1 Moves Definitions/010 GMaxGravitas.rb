module Battle
  class Move
    class GMaxGravitas < MaxMove
      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.terrain_effects.add(Effects::Gravity.new(@logic)) unless @logic.terrain_effects.has?(:gravity)
      end
    end
    Move.register(:s_gmax_gravitas, GMaxGravitas)
  end
end
