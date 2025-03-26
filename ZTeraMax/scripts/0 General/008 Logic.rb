module Battle
  class Logic
    class MegaEvolve
      private

      # Function that checks if any action of the player is a mega evolve
      # @return [Boolean]
      # @note The method has been overriden to avoid checking for an Array Action, which would return true if any Action was a Dynamax Action
      def any_mega_player_action?
        @scene.player_actions.flatten.any? { |actions| actions.is_a?(Actions::Mega) }
      end
    end
  end
end
