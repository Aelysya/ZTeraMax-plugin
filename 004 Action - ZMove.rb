module Battle
  module Actions
    # Class describing the Z Move action
    class ZMove < Base
      # Get the user of this action
      # @return [PFM::PokemonBattler]
      attr_reader :user

      # Create a new mega evolution action
      # @param scene [Battle::Scene]
      # @param user [PFM::PokemonBattler]
      def initialize(scene, user)
        super(scene)
        @user = user
      end

      # Execute the action
      def execute
        @scene.logic.z_move.mark_as_used_z_move(@user)
      end

      private

      # Get the pre mega evolve message
      # @return [String]
      def pre_mega_evolution_message
        mega_evolution_with_mega_stone = @user.data.evolutions.find { |evolution| evolution.condition_data(:gemme) == @user.battle_item_db_symbol }
        return parse_text_with_pokemon(19, 1247, @user, PFM::Text::TRNAME[1] => @user.trainer_name) unless mega_evolution_with_mega_stone

        return parse_text_with_pokemon(
          19, 1165, @user,
          PFM::Text::PKNICK[0] => @user.given_name,
          PFM::Text::ITEM2[2] => @user.item_name,
          PFM::Text::TRNAME[1] => @user.trainer_name,
          PFM::Text::ITEM2[3] => @scene.logic.mega_evolve.mega_tool_name(@user)
        )
      end
    end
  end
end
