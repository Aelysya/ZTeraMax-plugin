module BattleUI
  module SkillChoiceAbstraction
    # Tell if the use of Z Moves is enabled
    # @return [Boolean]
    attr_accessor :zmove_enabled

    alias default_reset reset
    # Reset the Skill choice
    # @param pokemon [PFM::PokemonBattler]
    def reset(pokemon)
      @zmove_enabled = false
      default_reset(pokemon)
    end
  end
end
