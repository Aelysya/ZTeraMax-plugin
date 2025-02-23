module PFM
  class Pokemon
    module PokemonZMovesPlugin
      # Check if the Pokemon can mega evolve
      # @return [Integer, false] form index if the Pokemon can mega evolve, false otherwise
      def can_mega_evolve?
        return false if Z_CRYSTALS.include?(item_db_symbol)

        super
      end

      # Change Arceus's form based on its held item
      FORM_CALIBRATE[:arceus] = proc do
        next @form = ArceusItem.index(item_db_symbol).to_i if ArceusItem.include?(item_db_symbol)
        next @form = ArceusZCrystalItem.index(item_db_symbol).to_i if ArceusZCrystalItem.include?(item_db_symbol)
      end
    end

    prepend PokemonZMovesPlugin
  end
end
