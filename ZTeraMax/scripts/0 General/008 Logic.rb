module Battle
  class Logic
    # Reset the Pokémon's moveset to its original state and kill the Z-Power or Dynamax effects
    # @param pokemon [Pokemon] The Pokémon whose moveset is to be updated.
    def reset_to_original_moveset(pokemon)
      pokemon.effects.each do |effect|
        next unless effect.name == :z_power || effect.name == :dynamax

        effect.kill
      end

      pokemon.original_moveset.each_with_index do |move, i|
        pokemon.moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, move.pp, move.ppmax, @scene)
      end
    end
  end
end
