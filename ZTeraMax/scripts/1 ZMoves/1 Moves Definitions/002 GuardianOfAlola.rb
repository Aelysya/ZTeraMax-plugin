module Battle
  class Move
    class GuardianOfAlola < ZMove
      # Deals 3/4 of the target's current HP as fixed damage
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [Array<PFM::PokemonBattler>] target that will be affected by the move
      def damages(user, target)
        @critical = false
        @effectiveness = 1
        log_data("Forced HP Move: #{(target.hp / 4 * 3).clamp(1, Float::INFINITY).floor} HP")
        return (target.hp / 4 * 3).clamp(1, Float::INFINITY).floor
      end
    end
    Move.register(:s_guardian_of_alola, GuardianOfAlola)
  end
end
