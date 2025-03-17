module Battle
  module Effects
    class Ability
      class WanderingSpirit < Ability
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

      class Mummy < Ability
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
