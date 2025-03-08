module BattleUI
  class PokemonSprite < ShaderedSprite
    module DynamaxPlugin
      # Pokemon sprite zoom
      # @return [Integer]
      def sprite_zoom
        return 2 if @pokemon.effects.has?(:dynamaxed)

        super
      end
    end

    prepend DynamaxPlugin
  end
end
