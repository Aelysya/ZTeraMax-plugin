module Battle
  class Visual
    # Make the result of show_target_choice method
    # @param result [Array, :auto, :cancel]
    def stc_result(result = :auto)
      return @skill_choice_ui.pokemon if result == :cancel && @skill_choice_ui.pokemon.effects.get(&:force_next_move?)
      return nil if result == :cancel

      arr = [@skill_choice_ui.pokemon, @skill_choice_ui.result]
      if result.is_a?(Array)
        arr.concat(result)
      elsif result == :auto
        targets = @skill_choice_ui.result.battler_targets(@skill_choice_ui.pokemon, @scene.logic)
        if targets.empty?
          arr.concat([1, 0])
        else
          arr << targets.first.bank
          arr << targets.first.position
        end
      else
        return nil
      end
      arr << @skill_choice_ui.mega_enabled
      arr << @skill_choice_ui.z_move_enabled
      arr << @skill_choice_ui.dynamax_enabled
      return arr
    end
  end
end
