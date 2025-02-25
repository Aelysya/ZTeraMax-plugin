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
        super(scene)
      end
    end

    prepend LogicZMovePlugin
  end
end
