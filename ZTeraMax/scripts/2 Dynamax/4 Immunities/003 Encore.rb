module Battle
  class Move
    class Encore < Move
      module DynamaxPlugin
        private

        # Tell if the target can be Encore'd
        # @param target [PFM::PokemonBattler]
        # @return [Boolean]
        def cant_encore_target?(target)
          return true if target.effects.has?(:dynamaxed)

          super
        end
      end

      prepend DynamaxPlugin
    end
  end
end
