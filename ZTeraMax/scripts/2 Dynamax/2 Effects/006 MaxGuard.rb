module Battle
  module Effects
    class MaxGuard < Protect
      # Get the name of the effect
      # @return [Symbol]
      def name
        return :max_guard
      end

      # Function called when we try to check if the target evades the move
      # @param user [PFM::PokemonBattler]
      # @param target [PFM::PokemonBattler] expected target
      # @param move [Battle::Move]
      # @return [Boolean] if the target is evading the move
      def on_move_prevention_target(user, target, move)
        return false if move.db_symbol == :gmax_one_blow || move.db_symbol == :gmax_rapid_flow

        if trampling_move?(move) # Override the protect effect allowing trampling moves to go through
          play_protect_effect(user, target, move)
          return true
        end

        super
      end
    end
    Protect.register(:max_guard, MaxGuard)
  end
end
