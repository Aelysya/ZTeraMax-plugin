module PFM
  class Pokemon
    EFFECTS_TO_KILL = %i[dynamaxed z_power]

    # Reset the Pokémon's moveset to its original state
    # @param pokemon [Pokemon] The Pokémon whose moveset is to be updated.
    def reset_to_original_moveset
      effects.get(:dynamaxed)&.kill
      effects.get(:z_power)&.kill

      original_moveset.each_with_index do |move, i|
        moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, moveset[i].pp, move.ppmax, @scene)
      end
    end
  end
end
