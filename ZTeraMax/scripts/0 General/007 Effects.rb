module Battle
  module Effects
    # Implement the Protect effect
    class Protect < PokemonTiedEffectBase
      module ProtectZTeraMaxPlugin
        # Function called when we try to check if the target evades the move
        # @param user [PFM::PokemonBattler]
        # @param target [PFM::PokemonBattler] expected target
        # @param move [Battle::Move]
        # @return [Boolean] if the target is evading the move
        def on_move_prevention_target(user, target, move)
          return false if trampling_move?(move) # Manque le message je crois

          super
        end

        # Give the move mod3 mutiplier (after everything)
        # @param user [PFM::PokemonBattler] user of the move
        # @param target [PFM::PokemonBattler] target of the move
        # @param move [Battle::Move] move
        # @return [Float, Integer] multiplier
        def mod3_multiplier(_user, target, move)
          return 1 if target != @pokemon
          return 1 unless trampling_move?(move)

          return 0.25
        end

        # Check if the move is a Z Move or Dynamax Move
        # @param move [Battle::Move]
        # @return [Boolean]
        def trampling_move?(move)
          return true if move.instance_of?(Battle::Move::ZMove) || move.instance_of?(Battle::Move::MaxMove)

          return false
        end
      end

      prepend ProtectZTeraMaxPlugin
    end
  end
end
