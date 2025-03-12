module Battle
  class Move
    class ForceSwitch < BasicWithSuccessfulEffect
      module DynamaxPlugin
        # Function that deals the effect to the pokemon
        # @param user [PFM::PokemonBattler] user of the move
        # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
        def deal_effect(user, actual_targets)
          super(user, actual_targets.reject { |target| target.effects.has?(:dynamaxed) })
        end
      end

      prepend DynamaxPlugin
    end
  end
end
