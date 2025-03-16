module Battle
  module Effects
    class Ability
      class GorillaTactics < Ability
        module DynamaxPlugin
          # Give the atk modifier over given to the Pokemon with this effect
          # @return [Float, Integer] multiplier
          # @note The stat boost stops working when user is dynamaxed
          def atk_modifier
            return 1 if @target.effect.has?(:dynamaxed)

            super
          end

          private

          # Checks if the user can use the move
          # @param user [PFM::PokemonBattler]
          # @param move [Battle::Move]
          # @return [Boolean]
          # @note The move selection restriction stops working when user is dynamaxed
          def can_be_used?(user, move)
            return true if @target.effect.has?(:dynamaxed)

            super
          end
        end
      end

      prepend DynamaxPlugin
    end
  end
end
