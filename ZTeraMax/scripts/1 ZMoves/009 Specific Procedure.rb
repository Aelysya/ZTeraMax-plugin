module Battle
  class Move
    module MoveZMovePlugin
      module_function

      # Internal procedure of the move
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      def proceed_internal_z_move(user, targets)
        unless (actual_targets = proceed_internal_precheck(user, targets))
          return user.add_move_to_history(self, targets) && @logic.z_move.reset_to_original_moveset(user)
        end

        post_accuracy_check_effects(user, actual_targets)

        post_accuracy_check_move(user, actual_targets)

        play_animation(user, targets)

        deal_damage(user, actual_targets) &&
          effect_working?(user, actual_targets) &&
          deal_status(user, actual_targets) &&
          deal_stats(user, actual_targets) &&
          deal_z_effect(user, actual_targets)

        user.add_move_to_history(self, actual_targets)
        user.add_successful_move_to_history(self, actual_targets)
        @scene.visual.set_info_state(:move_animation)
        @scene.visual.wait_for_animation

        post_z_move_actions(user)
      end

      # Function that deals the Z-effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_z_effect(user, actual_targets)
        Z_STATUS_MOVES_EFFECTS[db_symbol].call(user, @scene) if @is_z && Z_STATUS_MOVES_EFFECTS.key?(db_symbol)
        deal_effect(user, actual_targets)
        return true
      end

      def post_z_move_actions(user)
        z_move_position = find_z_move_position(user)
        original_move = user.original_moveset[z_move_position]

        original_move.pp -= @logic.foes_of(user).any? { |foe| foe.alive? && foe.has_ability?(:pressure) } ? 2 : 1

        @logic.z_move.reset_to_original_moveset(user)
      end

      # Find the Z-Move position in the moveset of the Pokemon
      # @param pokemon [PFM::PokemonBattler]
      # @return [Integer]
      def find_z_move_position(pokemon)
        return 0 if pokemon.move_history.empty?

        pokemon.moveset.each_with_index do |move, i|
          return i if move && move.id == pokemon.move_history.last.move.id && move.pp == 0
        end
        return 0
      end

      # Return the chance of hit of the move
      # @param user [PFM::PokemonBattler] user of the move
      # @param target [PFM::PokemonBattler] target of the move
      # @return [Float]
      def chance_of_hit(user, target)
        return 100 if user.effects.has?(:z_power) && @is_z

        return super
      end
    end

    prepend MoveZMovePlugin
  end
end
