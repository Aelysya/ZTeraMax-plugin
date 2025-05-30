module PFM
  class PokemonBattler < Pokemon
    module TerastalPlugin
      # @return [Boolean] If the Pokémon is Terastallized
      attr_accessor :terastallized

      # @return [Array<Integer>] List of types that have been Stellar-boosted
      attr_accessor :stellar_boosted_types

      COPIED_PROPERTIES.concat(%i[@tera_type])

      # Create a new PokemonBattler
      # @param original [PFM::Pokemon] original Pokemon (protected during the battle)
      # @param scene [Battle::Scene] current battle scene
      # @param max_level [Integer] new max level for Online battle
      def initialize(original, scene, max_level = Float::INFINITY)
        super
        @terastallized = false
        @stellar_boosted_types = []
      end
    end
    prepend TerastalPlugin
  end
end
