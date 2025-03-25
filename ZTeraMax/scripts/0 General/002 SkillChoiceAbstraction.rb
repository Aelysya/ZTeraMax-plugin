module SkillChoiceAbstractionZTeraMaxPlugin
  # Tell if the use of Z Moves is enabled
  # @return [Boolean]
  attr_accessor :z_move_enabled

  # Tell if the use of Z Moves is enabled
  # @return [Boolean]
  attr_accessor :dynamax_enabled

  # Reset the Skill choice
  # @param pokemon [PFM::PokemonBattler]
  def reset(pokemon)
    @z_move_enabled = false
    @dynamax_enabled = false
    super
  end
end
BattleUI::SkillChoiceAbstraction.prepend(SkillChoiceAbstractionZTeraMaxPlugin)
