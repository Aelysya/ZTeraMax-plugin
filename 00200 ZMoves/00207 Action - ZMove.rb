module Battle
  module Actions
    # Class describing the Z-Move action
    class ZMove < Base
      # Get the user of this action
      # @return [PFM::PokemonBattler]
      attr_reader :user

      # Create a new Z-Move action
      # @param scene [Battle::Scene]
      # @param user [PFM::PokemonBattler]
      def initialize(scene, user)
        super(scene)
        @user = user
      end

      # Execute the action
      def execute
        @scene.logic.z_move.mark_as_z_move_used(@user)
        @scene.display_message_and_wait(pre_z_move_message)
      end

      private

      # Get the pre Z-Move message
      # @return [String]
      def pre_z_move_message
        return parse_text_with_pokemon(
          19, 1165, @user,
          PFM::Text::PKNICK[0] => @user.given_name,
          PFM::Text::ITEM2[2] => @user.item_name,
          PFM::Text::TRNAME[1] => @user.trainer_name,
          PFM::Text::ITEM2[3] => @scene.logic.z_move.z_move_tool_name(@user)
        )
      end
    end
  end
end
