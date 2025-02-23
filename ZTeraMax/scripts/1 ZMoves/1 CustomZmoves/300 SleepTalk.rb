module Battle
  class Move
    # Sleep Talk move
    class SleepTalkZ < SleepTalk
      # Function that tests if the user is able to use the move
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      # @note Thing that prevents the move from being used should be defined by :move_prevention_user Hook
      # @return [Boolean] if the procedure can continue
      def move_usable_by_user(user, targets)
        return true if is_z

        return super
      end

      private

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        return super unless is_z

        move = usable_moves(user).sample(random: @logic.generic_rng).dup
        move = logic.z_move.corresponding_z_move(move) unless move.status?
        def move.move_usable_by_user(user, targets)
          return true
        end
        use_another_move(move, user)
      end

      # Function that list all the moves the user can pick
      # @param user [PFM::PokemonBattler]
      # @return [Array<Battle::Move>]
      def usable_moves(user)
        return user.original_moveset.reject { |skill| CANNOT_BE_SELECTED_MOVES.include?(skill.db_symbol) } if is_z

        return super
      end
    end
    Move.register(:s_sleep_talk, SleepTalkZ)
  end
end
