module BattleUI
  module SkillChoiceAbstraction
    # Tell if the use of Z Moves is enabled
    # @return [Boolean]
    attr_accessor :z_move_enabled

    # Tell if the use of Z Moves is enabled
    # @return [Boolean]
    attr_accessor :dynamax_enabled

    alias default_reset reset
    # Reset the Skill choice
    # @param pokemon [PFM::PokemonBattler]
    def reset(pokemon)
      @z_move_enabled = false
      @dynamax_enabled = false
      default_reset(pokemon)
    end
  end
end
