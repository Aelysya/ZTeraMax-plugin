module PFM
  class Pokemon
    module ZMovesPlugin
      # List of Z-Crystals
      Z_CRYSTALS = %i[normalium_z fightinium_z flyinium_z poisonium_z groundium_z rockium_z buginium_z
                      ghostium_z steelium_z firium_z waterium_z grassium_z electrium_z psychium_z
                      icium_z dragonium_z darkinium_z fairium_z aloraichium_z decidium_z eevium_z
                      incinium_z kommonium_z lunalium_z lycanium_z marshadium_z mewnium_z mimikium_z
                      pikanium_z pikashunium_z primarium_z snorlium_z solganium_z tapunium_z ultranecrozium_z]

      # List of Z-Crystals that can change Arceus's form
      ArceusZCrystalItem = %i[normalium_z firium_z waterium_z electrium_z grassium_z
                              icium_z fightinium_z poisonium_z groundium_z flyinium_z
                              psychium_z buginium_z rockium_z ghostium_z dragonium_z
                              steelium_z darkinium_z fairium_z]

      # Check if the Pokemon can mega evolve
      # @return [Integer, false] form index if the Pokemon can mega evolve, false otherwise
      # @note itemless Mega Evolution can't Mega if they hold a Z-Crystal (Rayquaza)
      def can_mega_evolve?
        return false if holds_z_crystal?

        super
      end

      # Check if the Pokémon holds a Z-Crystal item
      # @return [Boolean] If the Pokémon holds a Z-Crystal
      def holds_z_crystal?
        return Z_CRYSTALS.include?(battle_item_db_symbol)
      end

      # Change Arceus's form based on its held item
      FORM_CALIBRATE[:arceus] = proc do
        next @form = ArceusItem.index(item_db_symbol).to_i if ArceusItem.include?(item_db_symbol)
        next @form = ArceusZCrystalItem.index(item_db_symbol).to_i if ArceusZCrystalItem.include?(item_db_symbol)

        next 0
      end
    end
    prepend ZMovesPlugin
  end
end
