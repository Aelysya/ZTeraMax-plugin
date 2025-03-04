module Battle
  class Logic
    class MegaEvolve
      private

      # Function that checks if any action of the player is a mega evolve
      # @return [Boolean]
      def any_mega_player_action?
        @scene.player_actions.any? { |actions| actions.is_a?(Actions::Mega) }
      end
    end
  end
end
