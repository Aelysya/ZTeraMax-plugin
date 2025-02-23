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
        puts "3: #{is_z}"
        return super unless is_z

        move = usable_moves(user).sample(random: @logic.generic_rng).dup
        move = logic.z_move.replace_with_type_z_move(user, move) unless move.status?
        def move.move_usable_by_user(user, targets)
          return true
        end
        use_another_move(move, user)
      end
    end
    Move.register(:s_sleep_talk, SleepTalkZ)
  end
end
