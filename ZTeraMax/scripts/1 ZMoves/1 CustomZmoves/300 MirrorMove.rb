module Battle
  class Move
    # Move that mimics the last move of the choosen target
    class MirrorMoveZ < MirrorMove
      # Function that tests if the user is able to use the move
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      # @note Thing that prevents the move from being used should be defined by :move_prevention_user Hook
      # @return [Boolean] if the procedure can continue
      def move_usable_by_user(user, targets)
        return super unless is_z
        return false if last_move(user, targets).is_z

        return true
      end

      # Function that deals the effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_effect(user, actual_targets)
        move = last_move(user, actual_targets).dup
        move = logic.z_move.corresponding_z_move(move) unless move.status?

        def move.move_usable_by_user(user, targets)
          return true
        end
        use_another_move(move, user)
      end
    end

    Move.register(:s_mirror_move, MirrorMoveZ)
  end
end
