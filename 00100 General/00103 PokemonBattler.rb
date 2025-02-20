module PFM
  # Class defining a Pokemon during a battle, it aim to copy its properties but also to have the methods related to the battle.
  class PokemonBattler < Pokemon
    module PokemonBattlerZMovePlugin
      # @return [Array<Battle::Move>] the original moveset of the Pokemon
      attr_accessor :original_moveset

      # Create a new SkillChoice UI
      # @param viewport [Viewport]
      # @param scene [Battle::Scene]
      def initialize(viewport, scene)
        super(viewport, scene)
        @original_moveset = []
      end
    end

    prepend PokemonBattlerZMovePlugin
  end
end
