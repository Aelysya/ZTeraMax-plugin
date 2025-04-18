module Battle
  module Actions
    # Class describing the Terastal action
    class Terastal < Base
      # Get the user of this action
      # @return [PFM::PokemonBattler]
      attr_reader :user

      # Create a new Terastal action
      # @param scene [Battle::Scene]
      # @param user [PFM::PokemonBattler]
      def initialize(scene, user)
        super(scene)
        @user = user
      end

      # Compare this action with another
      # @param other [Base] other action
      # @return [Integer]
      def <=>(other)
        return 1 if other.is_a?(HighPriorityItem)
        return 1 if other.is_a?(Attack) && Attack.from(other).pursuit_enabled
        return 1 if other.is_a?(Item)
        return 1 if other.is_a?(Switch)
        return Terastal.from(other).user.spd <=> @user.spd if other.is_a?(Terastal)

        return -1
      end

      # Execute the action
      def execute
        @scene.logic.terastal.mark_as_terastal_used(@user)
        @user.terastallized = true
        $game_switches[Configs.z_tera_max.dynamax_enabled_switch] = false if $game_switches[Configs.z_tera_max.tera_orb_charge_enabled_switch]
      end
    end
  end
end
