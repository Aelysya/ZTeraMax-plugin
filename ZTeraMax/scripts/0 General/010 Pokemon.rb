module PFM
  class Pokemon
    # Reset the Pokémon's moveset to its original state
    # @param pokemon [Pokemon] The Pokémon whose moveset is to be updated.
    def reset_to_original_moveset
      effects.each do |effect|
        next unless effect.name == :z_power || effect.name == :dynamaxed

        effect.kill
      end

      original_moveset.each_with_index do |move, i|
        moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, moveset[i].pp, move.ppmax, @scene)
      end
    end
  end
end
