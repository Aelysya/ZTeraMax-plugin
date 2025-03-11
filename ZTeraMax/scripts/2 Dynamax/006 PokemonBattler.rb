module PFM
  class PokemonBattler < Pokemon
    module DynamaxPlugin
      COPIED_PROPERTIES.concat(%i[@dynamax_level @gigantamax_factor])

      # Create a new PokemonBattler
      # @param viewport [Viewport]
      # @param scene [Battle::Scene]
      def dynamax
        effects.add(Battle::Effects::Dynamaxed.new(@scene.logic, self))
        @hp = (@hp * (1.5 + 0.05 * @dynamax_level)).ceil
      end

      # Return the max HP of the Pokemon
      # @return [Integer]
      def max_hp
        if effects.has?(:dynamaxed)
          return 1 if db_symbol == :shedinja

          bonus_hp = 0.5 + 0.05 * @dynamax_level
          hp = super

          return (hp + hp * bonus_hp).ceil
        end

        return super
      end
    end

    prepend DynamaxPlugin
  end
end
