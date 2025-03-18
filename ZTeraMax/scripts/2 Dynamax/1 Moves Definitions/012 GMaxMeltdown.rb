module Battle
  class Move
    class GMaxMeltdown < MaxMove
      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        @logic.foes_of(user).each do |target|
          next if target.effects.has?(:torment) || target.effects.has?(:dynamaxed)

          target.effects.add(Effects::Torment.new(@logic, target))
          @scene.display_message_and_wait(parse_text_with_pokemon(19, 577, target))
        end
      end
    end
    Move.register(:s_gmax_meltdown, GMaxMeltdown)
  end
end
