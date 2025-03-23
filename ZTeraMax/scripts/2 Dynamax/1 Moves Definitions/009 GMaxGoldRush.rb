module Battle
  class Move
    class GMaxGoldRush < MaxMove
      private

      # Function that deals the effect (generates money the player gains at the end of battle)
      # @param user [PFM::PokemonBattler] user of the move
      # @param _actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, _actual_targets)
        return unless user.from_party?

        m = user.level * 100
        scene.battle_info.additional_money += m
        scene.display_message_and_wait(parse_text(18, 128))
      end
    end
    Move.register(:s_gmax_gold_rush, GMaxGoldRush)
  end
end
