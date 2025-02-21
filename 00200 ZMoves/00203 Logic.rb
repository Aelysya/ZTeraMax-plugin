module Battle
  class Logic
    module LogicZMovePlugin
      # Get the ZMove helper
      # @return [ZMove]
      attr_reader :z_move

      # Create a new Logic instance
      # @param scene [Scene] scene that hold the logic object
      def initialize(scene)
        # ZMove helper
        @z_move = ZMoves.new(scene)
        @used_z_tool_bags = []
        super(scene)
      end

      # Mark a pokemon's team as Z-Move consumed
      # @param pokemon [PFM::PokemonBattler]
      def mark_as_z_move_used(pokemon)
        @used_z_moves_tool_bags << pokemon.bag
      end
    end

    prepend LogicZMovePlugin
  end
end
