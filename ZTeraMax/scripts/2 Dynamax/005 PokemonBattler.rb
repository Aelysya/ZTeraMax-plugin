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
        form_calibrate(:gigantamax) if @gigantamax_factor
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

      # Copy all the properties back to the original pokemon
      def copy_properties_back_to_original
        effects.each do |effect|
          next unless effect.name == :dynamaxed

          effect.kill
        end

        super
      end
    end

    prepend DynamaxPlugin
  end
end
