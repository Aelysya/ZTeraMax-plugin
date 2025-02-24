module Battle
  module Effects
    class Taunt < PokemonTiedEffectBase
      # Function called when we try to check if the user cannot use a move
      # @param user [PFM::PokemonBattler]
      # @param move [Battle::Move]
      # @return [Proc, nil]
      def on_move_disabled_check(user, move)
        return if user != @pokemon
        return if move.is_z
        return unless move.status?

        return proc {
          move.scene.display_message_and_wait(parse_text_with_pokemon(19, 571, user, PFM::Text::MOVE[1] => move.name))
        }
      end

      # Function called when we try to use a move as the user (returns :prevent if user fails)
      # @param user [PFM::PokemonBattler]
      # @param targets [Array<PFM::PokemonBattler>]
      # @param move [Battle::Move]
      # @return [:prevent, nil] :prevent if the move cannot continue
      def on_move_prevention_user(user, targets, move)
        return if user != @pokemon
        return if move.is_z
        return unless move.status?

        move.scene.display_message_and_wait(parse_text_with_pokemon(19, 571, user, PFM::Text::MOVE[1] => move.name))
        return :prevent
      end
    end
  end
end
