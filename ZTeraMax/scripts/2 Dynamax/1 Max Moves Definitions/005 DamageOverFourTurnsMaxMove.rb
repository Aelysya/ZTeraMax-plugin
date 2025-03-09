module Battle
  class Move
    class DamageOverFourTurnsMaxMove < MaxMove
      private

      # Test if the effect is working
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      # @return [Boolean]
      def effect_working?(user, actual_targets)
        !@logic.foes_of(user).all? { |target|
          @logic.bank_effects[target.bank].has?(:damage_over_four_turns) &&
            @logic.bank_effects[target.bank].get(:damage_over_four_turns).position == target.position
        }
      end

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.foes_of(user).each do |target|
          next if @logic.bank_effects[target.bank].has?(:damage_over_four_turns) &&
                  @logic.bank_effects[target.bank].get(:damage_over_four_turns).position == target.position

          @logic.bank_effects[target.bank].add(Battle::Effects::DamageOverFourTurns.new(@logic, target.bank, target.position, self))
        end
      end
    end
    Move.register(:s_damage_over_four_turns_max_move, DamageOverFourTurnsMaxMove)
  end
end
