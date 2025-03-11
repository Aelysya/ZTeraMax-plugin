module PFM
  # Class defining a Pokemon during a battle, it aim to copy its properties but also to have the methods related to the battle.
  class PokemonBattler < Pokemon
    module PokemonBattlerZTeraMaxPlugin
      # @return [Array<Battle::Move>] the original moveset of the Pokemon
      attr_accessor :original_moveset

      # List of moves that should ignore abilities
      MOVES_IGNORING_ABILITIES.concat(%i[searing_sunraze_smash menacing_moonraze_maelstrom light_that_burns_the_sky
                                         gmax_drum_solo gmax_fireball gmax_hydrosnipe])

      # Create a new PokemonBattler
      # @param viewport [Viewport]
      # @param scene [Battle::Scene]
      def initialize(original, scene, max_level = Float::INFINITY)
        super
        @original_moveset = []
      end
    end

    prepend PokemonBattlerZTeraMaxPlugin
  end
end
