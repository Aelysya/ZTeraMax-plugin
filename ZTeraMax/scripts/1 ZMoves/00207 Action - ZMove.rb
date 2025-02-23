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
      end
    end
  end
end
