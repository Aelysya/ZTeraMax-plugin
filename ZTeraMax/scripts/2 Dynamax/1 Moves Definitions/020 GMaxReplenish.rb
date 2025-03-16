module Battle
  class Move
    class GMaxReplenish < MaxMove
      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        [user].concat(@logic.allies_of(user)).each do |target|
          next unless target.item_consumed && target.consumed_item != :__undef__

          @scene.logic.item_change_handler.change_item(target.consumed_item, true, target, user, self) if rand(100) < 50
        end
      end
    end
    Move.register(:s_gmax_replenish, GMaxReplenish)
  end
end
