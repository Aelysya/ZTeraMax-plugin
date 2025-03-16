module Battle
  class Move
    class GMaxSnooze < MaxMove
      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.foes_of(user).each do |target|
          next unless can_target_get_drowsy?(target)

          target.effects.add(Effects::Drowsiness.new(@logic, target, 2, user)) if rand(100) < 50
        end
      end

      def can_target_get_drowsy?(target)
        return false if target.status?
        return false if %i[drowsiness substitute].any? { |db_symbol| target.effects.has?(db_symbol) } || target.status?
        return false if %i[insomnia vital_spirit comatose].include?(target.battle_ability_db_symbol)
        return false if ($env.sunny? || $env.hardsun?) && target.has_ability?(:leaf_guard)
        return false if target.db_symbol == :minior && target.form == 0

        return true
      end
    end
    Move.register(:s_gmax_snooze, GMaxSnooze)
  end
end
