module PFM
  # Class defining a Pokemon during a battle, it aim to copy its properties but also to have the methods related to the battle.
  class PokemonBattler < Pokemon
    module DynamaxPlugin
      # Create a new PokemonBattler
      # @param viewport [Viewport]
      # @param scene [Battle::Scene]
      def dynamax
        effects.add(Battle::Effects::Dynamaxed.new(@scene.logic, self))
      end
    end

    prepend DynamaxPlugin
  end
end
