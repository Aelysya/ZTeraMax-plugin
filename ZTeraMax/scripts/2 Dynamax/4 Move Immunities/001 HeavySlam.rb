module Battle
  class Move
    class HeavySlam < Basic
      module DynamaxPlugin
        # @param user [PFM::PokemonBattler] user of the move
        # @param targets [Array<PFM::PokemonBattler>] expected targets
        # @note Thing that prevents the move from being used should be defined by :move_prevention_user Hook
        # @return [Boolean] if the procedure can continue
        def move_usable_by_user(user, targets)
          return show_usage_failure(user) && false if targets.all? { |target| target.effects.has?(:dynamaxed) }

          super
        end
      end

      prepend DynamaxPlugin
    end
  end
end
