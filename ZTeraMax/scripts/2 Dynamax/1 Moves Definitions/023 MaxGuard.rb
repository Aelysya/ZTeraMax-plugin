module Battle
  class Move
    class MaxGuard < Protect
      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        actual_targets.each do |target|
          target.effects.add(Effects::MaxGuard.new(@logic, target, self))
          scene.display_message_and_wait(parse_text_with_pokemon(19, 517, target))
        end
      end
    end
    Move.register(:s_max_guard, MaxGuard)
  end
end
