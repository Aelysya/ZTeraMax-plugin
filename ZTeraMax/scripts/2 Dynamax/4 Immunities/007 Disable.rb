module Battle
  class Move
    class Disable < Move
      module DynamaxPlugin
        # Function that tests if the targets blocks the move
        # @param user [PFM::PokemonBattler] user of the move
        # @param target [PFM::PokemonBattler] expected target
        # @note Thing that prevents the move from being used should be defined by :move_prevention_target Hook.
        # @return [Boolean] if the target evade the move (and is not selected)
        def move_blocked_by_target?(user, target)
          return failure_message if target.effects.has?(:dynamaxed)

          super
        end
      end

      prepend DynamaxPlugin
    end
  end

  module Effects
    class Ability
      class CursedBody < Ability
        module DynamaxPlugin
          # Function called after damages were applied (post_damage, when target is still alive)
          # @param handler [Battle::Logic::DamageHandler]
          # @param hp [Integer] number of hp (damage) dealt
          # @param target [PFM::PokemonBattler]
          # @param launcher [PFM::PokemonBattler, nil] Potential launcher of a move
          # @param skill [Battle::Move, nil] Potential move used
          def on_post_damage(handler, hp, target, launcher, skill)
            return if target.effects.has?(:dynamaxed)

            super
          end
        end

        prepend DynamaxPlugin
      end
    end
  end
end
