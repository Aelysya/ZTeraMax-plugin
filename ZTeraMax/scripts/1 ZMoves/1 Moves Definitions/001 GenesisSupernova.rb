module Battle
  class Move
    class GenesisSupernova < ZMove
      # Sets terrain to psychic terrain
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        logic.fterrain_change_handler.fterrain_change_with_process(:psychic_terrain, 5)
      end
    end
    Move.register(:s_genesis_supernova, GenesisSupernova)
  end
end
