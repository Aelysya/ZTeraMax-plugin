module Battle
  class Move
    class Instruct < Move
      module DynamaxPlugin
        private

        # @param user [PFM::PokemonBattler] user of the move
        # @param target [PFM::PokemonBattler] expected target
        # @return [Boolean] if the procedure can continue
        def move_usable?(user, target)
          return false if target.effects.has?(:dynamaxed)

          super
        end
      end

      prepend DynamaxPlugin
    end
  end
end
