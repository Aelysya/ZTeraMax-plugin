module Battle
  module Effects
    # Implement the Protect effect
    class Protect < PokemonTiedEffectBase
      # Function called when we try to check if the target evades the move
      # @param user [PFM::PokemonBattler]
      # @param target [PFM::PokemonBattler] expected target
      # @param move [Battle::Move]
      # @return [Boolean] if the target is evading the move
      def on_move_prevention_target(user, target, move)
        return false if goes_through_protect?(user, target, move)
        return false if z_move?(move) # Manque le message je crois

        play_protect_effect(user, target, move)
        return true
      end

      # Give the move mod3 mutiplier (after everything)
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @param move [Battle::Move] move
      # @return [Float, Integer] multiplier
      def mod3_multiplier(_user, target, move)
        return 1 if target != @pokemon
        return 1 unless z_move?(move)

        return 0.25
      end

      # Check if the move is a Z Move or Dynamax Move
      # @param move [Battle::Move]
      # @return [Boolean]
      def z_move?(move)
        return true if move.instance_of?(Battle::Move::ZMove)

        return false
      end
    end
  end
end
