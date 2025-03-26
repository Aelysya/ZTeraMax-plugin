module PFM
  class PokemonBattler < Pokemon
    module DynamaxPlugin
      # @return [Boolean] If the Pokémon is Dynamaxed
      attr_accessor :dynamaxed

      # @return [Integer, Boolean] Holds the original form of the Pokémon when it is Gigantamaxed, false when not Gigantamaxed
      attr_accessor :gigantamaxed

      COPIED_PROPERTIES.concat(%i[@dynamax_level @gigantamax_factor])

      # Create a new PokemonBattler
      # @param original [PFM::Pokemon] original Pokemon (protected during the battle)
      # @param scene [Battle::Scene] current battle scene
      # @param max_level [Integer] new max level for Online battle
      def initialize(original, scene, max_level = Float::INFINITY)
        super
        @dynamaxed = false
        @gigantamaxed = false
      end

      # Check if the Pokemon can Dynamax
      # @return [Integer, false] form index if the Pokemon can Dynamax, false otherwise
      def can_gigantamax?
        return false unless @gigantamax_factor

        return 40 unless db_symbol == :urshifu || db_symbol == :toxtricity

        return @form + 40
      end

      # Boost Pokemon's HP after Dynamax and change its form to Gigantamax if appliable
      def dynamax
        @hp = (@hp * (1.5 + 0.05 * @dynamax_level.to_i)).ceil
        @dynamaxed = true

        gigantamax_form = can_gigantamax?
        return unless gigantamax_form

        @gigantamaxed = @form # Keep original form in memory
        @form = gigantamax_form
      end

      # Reset the Pokemon to its normal form after Dynamax
      def undynamax
        return unless @dynamaxed

        reset_to_original_moveset
        @hp = (@hp / (1.5 + 0.05 * @dynamax_level.to_i)).ceil.clamp(0, max_hp)
        @dynamaxed = false

        if @gigantamaxed
          @form = @gigantamaxed
          @gigantamaxed = false
        end
      end

      # Return the max HP of the Pokemon
      # @return [Integer]
      def max_hp
        if effects.has?(:dynamaxed)
          return 1 if db_symbol == :shedinja

          bonus_hp = 0.5 + 0.05 * @dynamax_level.to_i
          hp = super

          return (hp + hp * bonus_hp).ceil
        end

        return super
      end

      # Copy all the properties back to the original pokemon
      def copy_properties_back_to_original
        effects.get(:dynamaxed)&.kill

        super
      end
    end
    prepend DynamaxPlugin
  end
end
