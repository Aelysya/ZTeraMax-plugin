module Battle
  module Actions
    # Class describing the Z-Move action
    class ZMove < Attack
      module ZMovesPlugin
        # Get the user of this action
        # @return [PFM::PokemonBattler]
        attr_reader :user

        # Create a new Z-Move action
        # @param scene [Battle::Scene]
        # @param user [PFM::PokemonBattler]
        def initialize(scene, move, launcher, target_bank, target_position)
          super(scene, move, launcher, target_bank, target_position)
          @user = launcher
        end

        # Execute the action
        def execute
          super
          @scene.logic.z_move.mark_as_z_move_used(@user) if @move.is_z
        end
      end

      prepend ZMovesPlugin
    end
  end
end
