module Battle
  class Move
    module MoveZMovePlugin
      module_function

      NO_REVERT_Z_MOVES = %i[mimic sketch]

      # Function that handles the Z-effect of increasing one of the user's stats by 1 stage
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def apply_stat_change(stat, value, user, scene)
        scene.logic.stat_change_handler.stat_change_with_process(stat, value, user, user, self)
      end

      # Function that handles the Z-effect of increasing all user's stats by 1 stage
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def increase_all_stats(user, scene)
        scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self)
        scene.logic.stat_change_handler.stat_change_with_process(:dfe, 1, user, user, self)
        scene.logic.stat_change_handler.stat_change_with_process(:ats, 1, user, user, self)
        scene.logic.stat_change_handler.stat_change_with_process(:dfs, 1, user, user, self)
        scene.logic.stat_change_handler.stat_change_with_process(:spd, 1, user, user, self)
      end

      # Function that handles the Z-effect of resetting negative changes on the user's stats
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def reset_decreased_stats(user, scene)
        return if user.battle_stage.none? { |stage| stage < 0 }

        user.battle_stage.map! { |stage| stage < 0 ? 0 : stage }
        scene.display_message_and_wait(parse_text_with_pokemon(19, 195, user))
      end

      # Function that handles the Z-effect of focusing the attention on the user
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def focus_attention(user, scene)
        user.effects.add(Effects::CenterOfAttention.new(@logic, user, 1, self))
        scene.display_message_and_wait(parse_text_with_pokemon(19, 670, user))
      end

      # Function that handles the Z-effect of increasing the crit ratio of the user
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def boost_crit_ratio(user, scene)
        return if %i[dragon_cheer focus_energy triple_arrows].any? { |e| user.effects.has?(e) }

        user.effects.add(Effects::FocusEnergy.new(@logic, user))
        scene.display_message_and_wait(parse_text_with_pokemon(19, 1047, user))
      end

      # Function that handles the Z-effect of Curse
      # @param user [PFM::PokemonBattler] user of the move
      # @param scene [PFM::Battle::Scene] scene of the battle
      def z_curse(user, scene)
        if user.type_ghost?
          scene.logic.damage_handler.heal(user, user.max_hp)
        else
          scene.logic.stat_change_handler.stat_change_with_process(:atk, 1, user, user, self)
        end
      end

      # Internal procedure of the move
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      def proceed_internal(user, targets)
        return user.add_move_to_history(self, targets) unless (actual_targets = proceed_internal_precheck(user, targets))

        post_accuracy_check_effects(user, actual_targets)

        post_accuracy_check_move(user, actual_targets)

        play_animation(user, targets)

        deal_damage(user, actual_targets) &&
          effect_working?(user, actual_targets) &&
          deal_status(user, actual_targets) &&
          deal_stats(user, actual_targets) &&
          deal_z_effect(user, actual_targets) &&
          deal_effect(user, actual_targets)

        user.add_move_to_history(self, actual_targets)
        user.add_successful_move_to_history(self, actual_targets)
        @scene.visual.set_info_state(:move_animation)
        @scene.visual.wait_for_animation

        user.original_moveset.each_with_index do |move, i|
          user.moveset[i] = Battle::Move[move.be_method].new(move.db_symbol, move.pp, move.ppmax, @scene) unless NO_REVERT_Z_MOVES.include?(move.db_symbol)
        end
      end

      # Tell if the move accuracy is bypassed
      # @param user [PFM::PokemonBattler] user of the move
      # @param targets [Array<PFM::PokemonBattler>] expected targets
      # @return [Boolean]
      def bypass_accuracy?(user, targets)
        return true if @is_z

        return super(user, targets)
      end

      # Function that deals the Z-effect to the pokemon
      # @param user [PFM::PokemonBattler] user of the move
      # @param actual_targets [Array<PFM::PokemonBattler>] targets that will be affected by the move
      def deal_z_effect(user, actual_targets)
        return true unless @is_z
        return true unless status? && Z_STATUS_MOVES_EFFECTS.key?(db_symbol)

        Z_STATUS_MOVES_EFFECTS[db_symbol].call(user, @scene)
        return true
      end
    end

    prepend MoveZMovePlugin
  end

  module Effects
    # Healing Wish Effect
    class ZHealNextAlly < PokemonTiedEffectBase
      # Get the name of the effect
      # @return [Symbol]
      def name
        return :z_heal_next_ally
      end

      # Function called when a Pokemon has actually switched with another one
      # @param handler [Battle::Logic::SwitchHandler]
      # @param who [PFM::PokemonBattler] Pokemon that is switched out
      # @param with [PFM::PokemonBattler] Pokemon that is switched in
      def on_switch_event(handler, who, with)
        handler.logic.damage_handler.heal(with, with.max_hp, false)
      end
    end
  end
end
